// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Initializes a Core module, retrying if necessary.
protocol ModuleInitializer: AnyObject {

    /// The module to initialize.
    var module: InitializableModule { get }

    /// Initializes the module.
    /// - parameter completion: A completion handler to be executed when the initialization operation is done.
    func initialize(completion: @escaping (ModuleInitializationResult) -> Void)
}

/// Core's concrete implementation of ``ModuleInitializer``.
/// It retries failed initializations using the values defined in the app config.
final class ChartboostCoreModuleInitializer: ModuleInitializer {

    let module: InitializableModule

    @Injected(\.appConfig) private var appConfig

    /// A timer with a scheduled retry to initialize the module.
    private var initializationRetryTimer: ThreadSafeTimer?

    private let queue: DispatchQueue

    init(module: InitializableModule, queue: DispatchQueue) {
        self.module = module
        self.queue = queue
    }

    func initialize(completion: @escaping (ModuleInitializationResult) -> Void) {
        initialize(retryCount: 0, completion: completion)
    }

    private func initialize(retryCount: Int, completion: @escaping (ModuleInitializationResult) -> Void) {

        let startDate = Date()

        // Start module initialization
        module.initialize { [weak self] error in
            guard let self else { return }

            self.queue.async {

                func callCompletion() {
                    completion(ModuleInitializationResult(startDate: startDate, error: error, module: self.module))
                }

                if let error {
                    // Initialization error
                    if retryCount < self.appConfig.moduleInitializationRetryCountMax {
                        // Schedule a retry
                        let newRetryCount = retryCount + 1
                        let delay = Math.retryDelayInterval(
                            retryNumber: newRetryCount,
                            base: self.appConfig.moduleInitializationDelayBase,
                            limit: self.appConfig.moduleInitializationDelayMax
                        )
                        
                        logger.error("Failed to initialize module \(self.module.moduleID) with error: \(error). Retry #\(newRetryCount) in \(delay) seconds.")
                        self.initializationRetryTimer = ThreadSafeTimer.scheduledTimer(withTimeInterval: delay) { [weak self] _ in
                            guard let self else { return }
                            self.queue.async {
                                // Retry module initialization
                                logger.info("Retrying initialization of module \(self.module.moduleID)...")
                                self.initialize(retryCount: newRetryCount, completion: completion)
                            }
                        }
                    } else {
                        // Reached retry limit: done.
                        callCompletion()
                    }
                } else {
                    // Initialization success
                    callCompletion()
                }
            }
        }
    }
}
