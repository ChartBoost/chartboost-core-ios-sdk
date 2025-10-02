// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import AppTrackingTransparency
import ChartboostCoreSDK
import XCTest

/// Tests to validate that the Core SDK public API remains stable and is not modified by mistake breaking existing integrations.
class PublicAPIStabilityTests: XCTestCase {
    /// Validates the AdvertisingEnvironment public APIs.
    func testAdvertisingEnvironment() {
        let environment: AdvertisingEnvironment = ChartboostCore.advertisingEnvironment
        let _: ATTrackingManager.AuthorizationStatus = environment.appTrackingTransparencyStatus
        let _: String? = environment.advertisingID
        let _: String? = environment.bundleID
        let _: String? = environment.deviceLocale
        let _: String = environment.deviceMake
        let _: String = environment.deviceModel
        @available(iOS, deprecated: 14.0) // avoid the "deprecated-declarations" warning
        var testIsLimitAdTrackingEnabled: Bool { environment.isLimitAdTrackingEnabled }
        let _: String = environment.osName
        let _: String = environment.osVersion
        let _: Double = environment.screenHeightPixels
        let _: Double = environment.screenScale
        let _: Double = environment.screenWidthPixels
    }

    /// Validates the AnalyticsEnvironment public APIs.
    func testAnalyticsEnvironment() {
        let environment: AnalyticsEnvironment = ChartboostCore.analyticsEnvironment
        let _: ATTrackingManager.AuthorizationStatus = environment.appTrackingTransparencyStatus
        let _: TimeInterval = environment.appSessionDuration
        let _: String? = environment.appSessionID
        let _: String? = environment.appVersion
        let _: String? = environment.advertisingID
        let _: String? = environment.bundleID
        let _: String? = environment.deviceLocale
        let _: String = environment.deviceMake
        let _: String = environment.deviceModel
        let _: String? = environment.frameworkName
        let _: String? = environment.frameworkVersion
        @available(iOS, deprecated: 14.0) // avoid the "deprecated-declarations" warning
        var testIsLimitAdTrackingEnabled: Bool { environment.isLimitAdTrackingEnabled }
        let _: Bool = environment.isUserUnderage
        let _: NetworkConnectionType = environment.networkConnectionType
        let _: String = environment.osName
        let _: String = environment.osVersion
        let _: String? = environment.playerID
        let _: String? = environment.publisherAppID
        let _: String? = environment.publisherSessionID
        let _: Double = environment.screenHeightPixels
        let _: Double = environment.screenScale
        let _: Double = environment.screenWidthPixels
        let _: String? = environment.vendorID
        let _: VendorIDScope = environment.vendorIDScope
        let _: Double = environment.volume
        environment.userAgent { userAgent in
            let _: String? = userAgent
        }

        let observer: EnvironmentObserver? = nil
        if let observer {
            environment.addObserver(observer)
            environment.removeObserver(observer)
        }
    }

    /// Validates the AttributionEnvironment public APIs.
    func testAttributionEnvironment() {
        let environment: AttributionEnvironment = ChartboostCore.attributionEnvironment
        let _: String? = environment.advertisingID
        environment.userAgent { userAgent in
            let _: String? = userAgent
        }
    }

    /// Validates the ChartboostCore public APIs.
    func testChartboostCore() {
        let _: PublisherMetadata = ChartboostCore.publisherMetadata
        let _: AdvertisingEnvironment = ChartboostCore.advertisingEnvironment
        let _: AnalyticsEnvironment = ChartboostCore.analyticsEnvironment
        let _: AttributionEnvironment = ChartboostCore.attributionEnvironment
        let _: ConsentManagementPlatform = ChartboostCore.consent
        let _: String = ChartboostCore.sdkVersion

        let configurations: [SDKConfiguration] = [
            .init(chartboostAppID: "app ID"),
            .init(
                chartboostAppID: "app ID",
                modules: [ModuleMock()]
            ),
            .init(
                chartboostAppID: "app ID",
                skippedModuleIDs: ["module ID"]
            ),
            .init(
                chartboostAppID: "app ID",
                modules: [ModuleMock()],
                skippedModuleIDs: ["module ID"]
            ),
        ]

        let moduleObservers: [ModuleObserver?] = [ConcreteModuleObserver(), nil]

        configurations.forEach { configuration in
            moduleObservers.forEach { moduleObserver in
                ChartboostCore.initializeSDK(configuration: configuration, moduleObserver: moduleObserver)
            }
        }

        let _: LogLevel = ChartboostCore.logLevel
        ChartboostCore.logLevel = .warning

        ChartboostCore.attachLogHandler(ConcreteLogHandler())
        ChartboostCore.detachLogHandler(ConcreteLogHandler())
    }

    /// Validates the ChartboostCoreResult public APIs.
    func testChartboostCoreResult() {
        let result: ChartboostCoreResult? = nil
        if let result {
            let _: Date = result.startDate
            let _: Date = result.endDate
            let _: TimeInterval = result.duration
            let _: Error? = result.error
        }
    }

    /// Validates the ConsentAdapter public APIs.
    func testConsentAdapter() {
        let adapter: ConsentAdapter? = nil
        if let adapter {
            let _: Bool = adapter.shouldCollectConsent
            let _: [ConsentKey: ConsentValue] = adapter.consents

            let _: ConsentAdapterDelegate? = adapter.delegate
            adapter.delegate = ConsentAdapterDelegateMock()
            adapter.delegate = nil

            adapter.grantConsent(source: .user, completion: { result in
                let _: Bool = result
            })
            adapter.denyConsent(source: .developer) { result in
                let _: Bool = result
            }
            adapter.resetConsent {
                let _: Bool = $0
            }

            adapter.showConsentDialog(.concise, from: UIViewController(), completion: { result in
                let _: Bool = result
            })
            adapter.showConsentDialog(.detailed, from: UIViewController()) {
                let _: Bool = $0
            }

            let _: String = adapter.moduleID
            let _: String = adapter.moduleVersion
            let config: ModuleConfiguration? = nil

            if let config {
                let _: String = adapter.moduleID
                let _: String = adapter.moduleVersion

                adapter.initialize(configuration: config) { error in
                    let _: Error? = error
                }
                adapter.initialize(configuration: config, completion: { (error: Error?) in
                    let _: Error? = error
                })
            }

            adapter.log("", level: .verbose)
            adapter.log("", level: .debug)
            adapter.log("", level: .info)
            adapter.log("", level: .warning)
            adapter.log("", level: .error)
            adapter.log("", level: .disabled)
        }
    }

    /// Validates the ConsentDialogType public APIs.
    func testConsentDialogType() {
        let _: ConsentDialogType = .concise
        let _: ConsentDialogType = .detailed
    }

    /// Validates the ConsentKey public APIs.
    func testConsentKey() {
        let _: ConsentKey = ConsentKeys.ccpaOptIn
        let _: ConsentKey = ConsentKeys.gdprConsentGiven
        let _: ConsentKey = ConsentKeys.gpp
        let _: ConsentKey = ConsentKeys.tcf
        let _: ConsentKey = ConsentKeys.usp
        let _: ConsentKey = "custom standard"
        let _: String = ConsentKeys.ccpaOptIn
    }

    /// Validates the ConsentManagementPlatform public APIs.
    func testConsentManagementPlatform() {
        let cmp: ConsentManagementPlatform? = nil
        if let cmp {
            let _: Bool = cmp.shouldCollectConsent
            let _: [ConsentKey: ConsentValue] = cmp.consents

            cmp.grantConsent(source: .developer)
            cmp.grantConsent(source: .user)
            cmp.denyConsent(source: .developer)
            cmp.denyConsent(source: .user)
            cmp.resetConsent()

            cmp.grantConsent(source: .user, completion: { result in
                let _: Bool = result
            })
            cmp.denyConsent(source: .developer) { result in
                let _: Bool = result
            }
            cmp.resetConsent {
                let _: Bool = $0
            }

            cmp.showConsentDialog(.concise, from: UIViewController())
            cmp.showConsentDialog(.detailed, from: UIViewController())

            cmp.showConsentDialog(.concise, from: UIViewController(), completion: { result in
                let _: Bool = result
            })
            cmp.showConsentDialog(.detailed, from: UIViewController()) {
                let _: Bool = $0
            }

            cmp.addObserver(ConcreteConsentObserver())
            cmp.removeObserver(ConcreteConsentObserver())
        }
    }

    /// Validates the ConsentObserver public APIs.
    func testConsentObserver() {
        let observer: ConsentObserver? = nil
        observer?.onConsentModuleReady(initialConsents: ["some key": "some value"])
        observer?.onConsentChange(fullConsents: ["some key": "some value"], modifiedKeys: [ConsentKeys.ccpaOptIn])
        observer?.onConsentChange(fullConsents: [:], modifiedKeys: ["custom standard"])
        observer?.onConsentChange(fullConsents: [ConsentKeys.ccpaOptIn: ConsentValues.granted], modifiedKeys: [])
    }

    /// Validates the ConsentSource public APIs.
    func testConsentSource() {
        let _: ConsentSource = .user
        let _: ConsentSource = .developer
    }

    /// Validates the ConsentValue public APIs.
    func testConsentValue() {
        let _: ConsentValue = ConsentValues.denied
        let _: ConsentValue = ConsentValues.doesNotApply
        let _: ConsentValue = ConsentValues.granted
        let _: ConsentValue = "custom value"
        let _: String = ConsentValues.granted
    }

    /// Validates the ConsoleLogHandler public APIs.
    func testConsoleLogHandler() {
        let consoleLogHandler = ConsoleLogHandler()
        let _: LogLevel = consoleLogHandler.logLevel
        consoleLogHandler.logLevel = .error
        let logEntry: LogEntry? = nil
        if let logEntry {
            consoleLogHandler.handle(logEntry)
        }
    }

    /// Validates the EnvironmentObserver public APIs.
    func testEnvironmentObserver() {
        let observer: EnvironmentObserver? = nil
        observer?.onChange(.playerID)
    }

    /// Validates the LogEntry public APIs.
    func testLogEntry() {
        let logEntry: LogEntry? = nil
        if let logEntry {
            let _: String = logEntry.message
            let _: String = logEntry.subsystem
            let _: String = logEntry.category
            let _: Date = logEntry.date
            let _: LogLevel = logEntry.logLevel
        }
    }

    /// Validates the Logger public APIs.
    func testLogger() {
        let logger = Logger(id: "", name: "")
        _ = Logger(id: "", name: "", parent: nil)
        _ = Logger(id: "", name: "", parent: logger)
        let _: String = logger.subsystem
        let _: String = logger.name
        logger.attachHandler(LogHandlerMock())
        logger.detachHandler(LogHandlerMock())
        logger.verbose("")
        logger.debug("")
        logger.info("")
        logger.warning("")
        logger.error("")
        logger.log("", level: .debug)
    }

    /// Validates the LogHandler public APIs.
    func testLogHandler() {
        let logHandler: LogHandler? = nil
        let logEntry: LogEntry? = nil
        if let logHandler, let logEntry {
            logHandler.handle(logEntry)
        }
    }

    /// Validates the LogLevel public APIs.
    func testLogLevel() {
        let _: LogLevel = .verbose
        let _: LogLevel = .debug
        let _: LogLevel = .info
        let _: LogLevel = .warning
        let _: LogLevel = .error
        let _: LogLevel = .disabled

        let _: Int = LogLevel.info.rawValue
        let _: String = LogLevel.info.description
    }

    /// Validates the Module public APIs.
    func testModule() {
        let module: Module? = nil
        let config: ModuleConfiguration? = nil
        if let module, let config {
            let _: String = module.moduleID
            let _: String = module.moduleVersion

            module.initialize(configuration: config) { error in
                let _: Error? = error
            }
            module.initialize(configuration: config, completion: { (error: Error?) in
                let _: Error? = error
            })
        }
    }

    /// Validates the ModuleInitializationResult public APIs.
    func testModuleConfiguration() {
        let config: ModuleConfiguration? = nil
        if let config {
            let _: String = config.chartboostAppID
        }
    }

    /// Validates the ModuleInitializationResult public APIs.
    func testModuleInitializationResult() {
        let result: ModuleInitializationResult? = nil
        if let result {
            let _: Date = result.startDate
            let _: Date = result.endDate
            let _: TimeInterval = result.duration
            let _: Error? = result.error
            let _: String = result.moduleID
            let _: String = result.moduleVersion
        }
    }

    /// Validates the ModuleFactory public API.
    func testModuleFactory() {
        let moduleFactory: ModuleFactory? = nil
        let completion: (Module?) -> Void = { _ in }
        moduleFactory?.makeModule(className: "class_name", credentials: nil, completion: completion)
        moduleFactory?.makeModule(className: "class_name", credentials: ["string": ["any": 123]], completion: completion)
    }

    /// Validates the ModuleObserver public APIs.
    func testModuleObserver() {
        let observer: ModuleObserver? = nil
        let result: ModuleInitializationResult? = nil
        if let result {
            observer?.onModuleInitializationCompleted(result)
        }
    }

    /// Validates the NetworkConnectionType public APIs.
    func testNetworkConnectionType() {
        let _: NetworkConnectionType = .unknown
        let _: NetworkConnectionType = .wired
        let _: NetworkConnectionType = .wifi
        let _: NetworkConnectionType = .cellularUnknown
        let _: NetworkConnectionType = .cellular2G
        let _: NetworkConnectionType = .cellular3G
        let _: NetworkConnectionType = .cellular4G
        let _: NetworkConnectionType = .cellular5G
    }

    /// Validates the ObservableEnvironmentProperty public APIs.
    func testObservableEnvironmentProperty() {
        let _: ObservableEnvironmentProperty = .frameworkName
        let _: ObservableEnvironmentProperty = .frameworkVersion
        let _: ObservableEnvironmentProperty = .isUserUnderage
        let _: ObservableEnvironmentProperty = .playerID
        let _: ObservableEnvironmentProperty = .publisherAppID
        let _: ObservableEnvironmentProperty = .publisherSessionID

        let _: String = ObservableEnvironmentProperty.frameworkName.description
    }

    /// Validates the PublisherMetadata public APIs.
    func testPublisherMetadata() {
        let publisherMetadata: PublisherMetadata = ChartboostCore.publisherMetadata
        publisherMetadata.setFramework(name: "", version: "")
        publisherMetadata.setIsUserUnderage(true)
        publisherMetadata.setPlayerID("")
        publisherMetadata.setPublisherAppID("")
        publisherMetadata.setPublisherSessionID("")
    }

    /// Validates the SDKConfiguration public APIs.
    func testSDKConfiguration() {
        let configuration = SDKConfiguration(chartboostAppID: "some id")
        let _: String = configuration.chartboostAppID
    }

    /// Validates the VendorIDScope public APIs.
    func testVendorIDScope() {
        let _: VendorIDScope = .unknown
        let _: VendorIDScope = .application
        let _: VendorIDScope = .developer
    }
}

// MARK: - ConsentAdapter

class ConcreteConsentAdapter: ConsentAdapter {
    var moduleID: String { "" }

    var moduleVersion: String { "" }

    required init(credentials: [String: Any]?) {
    }

    func initialize(
        configuration: ModuleConfiguration,
        completion: @escaping (Error?) -> Void
    ) {
    }

    weak var delegate: ConsentAdapterDelegate?

    var shouldCollectConsent: Bool {
        false
    }

    var consents: [ConsentKey: ConsentValue] {
        [ConsentKeys.ccpaOptIn: ConsentValues.denied]
    }

    func grantConsent(source: ConsentSource, completion: @escaping (_ succeeded: Bool) -> Void) {
    }

    func denyConsent(source: ConsentSource, completion: @escaping (_ succeeded: Bool) -> Void) {
    }

    func resetConsent(completion: @escaping (_ succeeded: Bool) -> Void) {
    }

    func showConsentDialog(
        _ type: ConsentDialogType,
        from viewController: UIViewController,
        completion: @escaping (_ succeeded: Bool) -> Void
    ) {
    }
}

// MARK: - ConsentAdapterDelegate

class ConcreteConsentAdapterDelegate: ConsentAdapterDelegate {
    func onConsentChange(key: ConsentKey) {
    }
}

// MARK: - ConsentManagementPlatform

class ConcreteConsentManagementPlatform: ConsentManagementPlatform {
    var shouldCollectConsent: Bool {
        false
    }

    var consents: [ConsentKey: ConsentValue] {
        [ConsentKeys.ccpaOptIn: ConsentValues.granted]
    }

    func grantConsent(source: ConsentSource, completion: @escaping (_ succeeded: Bool) -> Void) {
    }

    func denyConsent(source: ConsentSource, completion: @escaping (_ succeeded: Bool) -> Void) {
    }

    func resetConsent(completion: @escaping (_ succeeded: Bool) -> Void) {
    }

    func showConsentDialog(
        _ type: ConsentDialogType,
        from viewController: UIViewController,
        completion: @escaping (_ succeeded: Bool) -> Void
    ) {
    }

    func addObserver(_ observer: ConsentObserver) {
    }

    func removeObserver(_ observer: ConsentObserver) {
    }
}

// MARK: - ConsentObserver

class ConcreteConsentObserver: ConsentObserver {
    func onConsentModuleReady(initialConsents: [ConsentKey: ConsentValue]) {
    }

    func onConsentChange(fullConsents: [ConsentKey: ConsentValue], modifiedKeys: Set<ConsentKey>) {
    }
}

// MARK: - EnvironmentObserver

class ConcreteEnvironmentObserver: EnvironmentObserver {
    func onChange(_ property: ObservableEnvironmentProperty) {
    }
}

// MARK: - LogHandler

class ConcreteLogHandler: LogHandler {
    func handle(_ entry: LogEntry) {
    }
}

// MARK: - Module

class ConcreteModule: Module {
    var moduleID: String { "" }

    var moduleVersion: String { "" }

    required init(credentials: [String: Any]?) {
    }

    func initialize(
        configuration: ModuleConfiguration,
        completion: @escaping (Error?) -> Void
    ) {
    }
}

// MARK: - ModuleObserver

class ConcreteModuleObserver: ModuleObserver {
    func onModuleInitializationCompleted(_ result: ModuleInitializationResult) {
    }
}
