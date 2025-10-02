// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Initializes the Core SDK.
protocol SDKInitializer {
    /// Initializes the Core SDK.
    /// - parameter configuration: Initialization configuration parameters.
    /// - parameter moduleObserver: An observer to be notified whenever a Core module finishes initialization.
    func initializeSDK(configuration: SDKConfiguration, moduleObserver: ModuleObserver?)
}

/// Core's concrete implementation of ``SDKInitializer``.
/// Client-side modules are initialized immediately, while backend-side modules require an app config
/// to be fetched from the backend.
/// Fetching the app config can be retried several times using the values defined in the app config.
final class ChartboostCoreSDKInitializer: SDKInitializer {
    /// The Core SDK initialization state.
    private enum InitializationState {
        /// Core is not initialized and no initialization operation is currently ongoing, although a retry may have been scheduled.
        /// - parameter retryCount: The number of retries up to this point.
        case notInitialized(retryCount: Int = 0)
        /// Core initialization is currently ongoing.
        case initializing
        /// Core is initialized.
        case initialized
    }

    private enum InitError: LocalizedError {
        case tooManyConsentAdapters

        var errorDescription: String? {
            switch self {
            case .tooManyConsentAdapters:
                return "Multiple `ConsentAdapter`s are provided, but only the first one is accepted."
            }
        }
    }

    @Injected(\.appConfig) private var appConfig
    @Injected(\.appConfigRepository) private var appConfigRepository
    @Injected(\.consentManager) private var consentManager
    @Injected(\.environmentChangePublisher) private var environmentChangePublisher
    @Injected(\.moduleFactory) private var moduleFactory
    @Injected(\.moduleInitializerFactory) private var moduleInitializerFactory
    @Injected(\.networkStatusProvider) private var networkStatusProvider
    @Injected(\.sessionInfoProvider) private var sessionInfoProvider
    @Injected(\.userAgentProvider) private var userAgentProvider

    private let queue = DispatchQueue(label: "com.chartboost.core.sdk_initializer")

    private weak var moduleObserver: ModuleObserver? {
        willSet {
            if moduleObserver != nil {
                logger.info("Replacing module observer, the old observer will no longer receive initialization callbacks.")
            }
        }
    }

    /// The current Core initialization state.
    private var state: InitializationState = .notInitialized()
    /// A timer with a scheduled retry to initialize Core, if fetching the app config failed.
    private var initializationRetryTimer: ThreadSafeTimer?
    /// List of module initializers where each module is currently initializing, either because
    /// the module is yet to report an initialization result, or because a retry has been scheduled.
    private var moduleInitializers: [ModuleInitializer] = []
    /// List of modules already initialized.
    private var initializedModules: [Module] = []

    func initializeSDK(configuration: SDKConfiguration, moduleObserver: ModuleObserver?) {
        queue.async { [self] in
            logger.debug("Initializing Core...")
            if !configuration.skippedModuleIDs.isEmpty {
                logger.info("Module IDs to skip: \(configuration.skippedModuleIDs)")
            }

            // Use existing Chartboost App ID from previous successful init if any
            let sanitizedConfiguration = sanitize(configuration)

            // Initial setup that has effect only on the first call
            updateSession()
            userAgentProvider.userAgent(completion: { _ in })
            // Start reachability notifier.
            networkStatusProvider.startNotifier()

            // Update the module observer that will receive module initialization callbacks
            self.moduleObserver = moduleObserver

            // Initialize client-side modules immediately
            if sanitizedConfiguration.modules.isEmpty {
                logger.debug("No client-side modules to initialize.")
            } else {
                logger.debug("Initializing client-side modules...")
                initializeModules(sanitizedConfiguration.modules, sdkConfig: sanitizedConfiguration, logWarningIfNoCMP: true)
            }
            // Fetch an app config (with retries) and then initialize backend modules
            fetchAppConfigAndInitializeBackendModules(configuration: sanitizedConfiguration)
        }
    }

    private func sanitize(_ configuration: SDKConfiguration) -> SDKConfiguration {
        guard let chartboostAppID = appConfig.chartboostAppID, chartboostAppID != configuration.chartboostAppID else {
            return configuration
        }
        logger.warning("Initializing with a different Chartboost App ID is not supported. Using previous ID '\(chartboostAppID)'")
        return SDKConfiguration(
            chartboostAppID: chartboostAppID,
            modules: configuration.modules,
            skippedModuleIDs: configuration.skippedModuleIDs
        )
    }

    private func fetchAppConfigAndInitializeBackendModules(configuration: SDKConfiguration) {
        switch state {
        case .notInitialized(let retryCount):
            // Cancel scheduled retry
            state = .initializing
            initializationRetryTimer?.cancel()

            // Fetch app config from backend (completion will be called immediately if a cached config from a previous session is available)
            logger.debug("Fetching app config...")
            appConfigRepository.fetchAppConfig(configuration: configuration) { [weak self] error in
                guard let self else { return }
                self.queue.async {
                    // Fetch success: we have a non-default app config now
                    if error == nil {
                        // Initialize backend modules
                        self.state = .initialized
                        logger.info("Core initialization completed")
                        self.instantiateAndInitializeBackendModules(configuration: configuration)
                    }
                    // Fetch failure: retry
                    else if retryCount < self.appConfig.coreInitializationRetryCountMax {
                        let newRetryCount = retryCount + 1
                        self.state = .notInitialized(retryCount: newRetryCount)

                        let delay = Math.retryDelayInterval(
                            retryNumber: newRetryCount,
                            base: self.appConfig.coreInitializationDelayBase,
                            limit: self.appConfig.coreInitializationDelayMax
                        )
                        logger.error("Failed to initialize Core. Retry #\(newRetryCount) in \(delay) seconds.")
                        self.initializationRetryTimer = .scheduledTimer(withTimeInterval: delay) { [weak self] _ in
                            guard let self else { return }
                            self.queue.async {
                                logger.info("Retrying Core initialization...")
                                self.fetchAppConfigAndInitializeBackendModules(configuration: configuration)
                            }
                        }
                    }
                    // Fetch failure: done
                    else {
                        self.state = .notInitialized()
                        logger.error("Failed to initialize Core. Reached limit of \(self.appConfig.coreInitializationRetryCountMax) retries.")
                    }
                }
            }
        case .initializing:
            // Do nothing, let ongoing operation continue.
            logger.info("Ignoring initialization call due to initialization operation already ongoing.")
        case .initialized:
            // Retry initialization of backend modules that previously failed.
            logger.debug("Core already initialized")
            instantiateAndInitializeBackendModules(configuration: configuration)
        }
    }

    /// Gets list of modules from backend config, instantiates them via reflection, and initializes them.
    private func instantiateAndInitializeBackendModules(configuration: SDKConfiguration) {
        // Skip if no remote modules info provided by backend.
        let moduleInfos = appConfig.modules
        guard !moduleInfos.isEmpty else {
            logger.debug("No backend-side modules to initialize.")
            return
        }
        // Instantiate modules skipping already initialized or initializing ones.
        for (index, moduleInfo) in moduleInfos.enumerated() {
            guard !initializedModules.map(\.moduleID).contains(moduleInfo.identifier)
                && !moduleInitializers.map(\.module.moduleID).contains(moduleInfo.identifier)
            else {
                continue
            }
            // Instantiate module which may be native or non-native (e.g. Unity)
            moduleFactory.makeModule(info: moduleInfo) { [weak self] module in
                guard let self else {
                    return
                }
                guard let module else {
                    logger.error("Failed to instantiate module \(moduleInfo.identifier)")
                    return
                }
                // Initialize instantiated module
                self.queue.async {
                    logger.debug("Initializing backend-side module \(module.moduleID)...")
                    // We log a warning if no CMP module is provided for the last element only, since we won't have info about
                    // all the modules until that last module is processed.
                    self.initializeModules([module], sdkConfig: configuration, logWarningIfNoCMP: index == moduleInfos.count - 1)
                }
            }
        }
    }

    /// Starts session if this is the first initialization attempt.
    private func updateSession() {
        if sessionInfoProvider.session == nil {
            sessionInfoProvider.reset()
        }
    }

    /// Picks a new CMP adapter module if needed, and logs warnings if input is incorrect. Dropped CMP adapters are returned as well.
    private func pickNewCMP(from modules: [Module], logWarningIfNoCMP: Bool) -> (newCMP: ConsentAdapter?, droppedCMPs: [Module]) {
        let cmps = modules.compactMap { $0 as? ConsentAdapter }

        // If a CMP adapter is already set we don't overwrite it.
        guard consentManager.adapter == nil else {
            return (nil, cmps)
        }
        // Log warning if initializing without a cmp, or if multiple cmps are provided
        if cmps.isEmpty
            && consentManager.adapter == nil
            && !moduleInitializers.contains(where: { $0.module is ConsentAdapter })
            && logWarningIfNoCMP
        {
            logger.warning(
                "No consent management platform module provided on initialization. " +
                "No user consent information will be available to modules."
            )
        }
        if cmps.count > 1 {
            logger.warning("Multiple consent management platform modules provided on initialization. The first one will be used.")
        }
        // Pick the first CMP
        return (cmps.first, Array(cmps.dropFirst()))
    }

    /// Initializes Core modules.
    /// Note that `modules` could be different from the initial modules in `sdkConfig.modules`.
    private func initializeModules(_ modules: [Module], sdkConfig: SDKConfiguration, logWarningIfNoCMP: Bool) {
        // Pick the consent adapter module if not set yet
        let (newCMP, droppedCMPs) = pickNewCMP(from: modules, logWarningIfNoCMP: logWarningIfNoCMP)

        for module in modules {
            // Discard skipped modules
            if sdkConfig.skippedModuleIDs.contains(module.moduleID) {
                logger.debug("Skipping module \(module.moduleID)")
            }
            // Discard already initialized modules
            else if let initializedModule = initializedModules.first(where: { $0.moduleID == module.moduleID }) {
                logger.debug("Skipping already initialized module \(module.moduleID)")
                // Report initialization success immediately for already initialized module
                moduleObserver?.onModuleInitializationCompleted(.init(startDate: Date(), error: nil, module: initializedModule))
            }
            // Discard already initializing modules
            else if moduleInitializers.lazy.map(\.module).contains(where: { $0.moduleID == module.moduleID }) {
                logger.debug("Skipping already initializing module \(module.moduleID)")
            }
            // Discard extra `ConsentAdapter` modules
            else if droppedCMPs.contains(where: { module === $0 }) {
                logger.error("\(module.moduleID) is discarded because another `ConsentAdapter` has been recognized")
                // Skip this module and report failure immediately
                moduleObserver?.onModuleInitializationCompleted(.init(
                    startDate: Date(),
                    error: InitError.tooManyConsentAdapters,
                    module: module
                ))
            }
            // Initialize new module
            else {
                logger.debug("Initializing module \(module.moduleID)...")

                // Create a module initializer and keep it alive ƒor as long as it is running
                let initializer = moduleInitializerFactory.makeModuleInitializer(module: module)
                moduleInitializers.append(initializer)
                // Start the module initialization
                initializer.initialize(configuration: .init(sdkConfiguration: sdkConfig)) { [weak self, weak initializer] result in
                    guard let self else { return }
                    self.queue.async {
                        // Keep the initialized module if success, discard it if failure.
                        if let error = result.error {
                            logger.error("Failed to initialize module \(module.moduleID) with error: \(error)")
                        } else {
                            logger.info("Initialized module \(module.moduleID)")
                            // Keep module alive and start sending observer updates to it
                            if let module = module as? ConsentObserver {
                                self.consentManager.addObserver(module)
                            }
                            if let module = module as? EnvironmentObserver {
                                self.environmentChangePublisher.addObserver(module)
                            }
                            self.initializedModules.append(module)

                            // Set the CMP
                            // This makes consent info available to all modules and triggers a call to onConsentModuleReady()
                            if module === newCMP {
                                logger.debug("Set new consent management platform")
                                self.consentManager.adapter = newCMP
                            }
                        }
                        // Report result to the user
                        DispatchQueue.main.async {  // on main thread in case the observer does some UI logic here
                            self.moduleObserver?.onModuleInitializationCompleted(result)
                        }
                        // Discard the module initializer, so initialization for this module can be triggered again
                        // by a new call to initializeSDK() by the user.
                        self.moduleInitializers.removeAll(where: { $0 === initializer })
                    }
                }
            }
        }
    }
}
