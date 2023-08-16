// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A repository that holds an app config and can fetch a new one from the backend.
protocol AppConfigRepository {

    /// The current app config.
    /// This may be a default hardcoded value if no backend config is available.
    var config: AppConfig { get }

    /// Fetches a new app config from the backend, updating the value for ``config``.
    /// - parameter configuration: The SDK configuration object passed by the publisher on initialization.
    /// - parameter completion: A completion handler executed when the fetch operation is done.
    func fetchAppConfig(with configuration: SDKConfiguration, completion: @escaping (Error?) -> Void)
}

// Extension with a definition of the default app config.
// This is private to force other components to fetch the current config from the ``AppConfigRepository``.
private extension AppConfig {

    /// A default app config with hardcoded values.
    static var `default`: AppConfig {
        AppConfig(
            coreInitializationDelayBase: 1,
            maxCoreInitializationDelay: 30,
            maxCoreInitializationRetryCount: 3,
            maxModuleInitializationDelay: 30,
            maxModuleInitializationRetryCount: 3,
            moduleInitializationDelayBase: 1,
            isChildDirected: nil,
            modules: []
        )
    }
}

/// Core's concrete implementation of ``AppConfigRepository``.
final class ChartboostCoreAppConfigRepository: AppConfigRepository {

    enum FetchAppConfigError: String, Error, Equatable {
        case receivedNilResponseBody = "Received no init response body from backend."
    }

    private let appConfigFileName = "config"

    @Injected(\.analyticsEnvironment) private var environment
    @Injected(\.appConfigFactory) private var appConfigFactory
    @Injected(\.appConfigRequestFactory) private var appConfigRequestFactory
    @Injected(\.jsonRepository) private var jsonRepository
    @Injected(\.networkManager) private var networkManager

    private var backendConfig: AppConfig?

    private let queue = DispatchQueue(label: "com.chartboost.core.app_config_repository")

    var config: AppConfig {
        backendConfig ?? .default
    }

    func fetchAppConfig(with configuration: SDKConfiguration, completion: @escaping (Error?) -> Void) {
        queue.async { [self] in
            // Complete immediately if a backend config is already cached, or if one can be retrieved from disk
            if backendConfig != nil || updateAppConfigFromDisk() {
                completion(nil)
                // Fetch a new config on the background
                updateAppConfigFromBackend(with: configuration, completion: nil)
            } else {
                // First fetch the config from the backend, and then complete
                updateAppConfigFromBackend(with: configuration, completion: completion)
            }
        }
    }

    private func updateAppConfigFromBackend(with configuration: SDKConfiguration, completion: ((Error?) -> Void)?) {
        // Make request to backend
        let request = appConfigRequestFactory.makeRequest(configuration: configuration, environment: environment)
        networkManager.send(request) { [weak self] response in
            guard let self else { return }
            self.queue.async {
                switch response.result {
                case .success(let responseBody):
                    // Success
                    if let responseBody {
                        // Parse the response, cache it, and persist it in disk for use in subsequent sessions.
                        logger.info("Fetched new app config from backend")
                        let appConfig = self.appConfigFactory.makeAppConfig(from: responseBody, fallbackValues: .default)
                        self.backendConfig = appConfig
                        self.persistAppConfig(appConfig)
                        completion?(nil)
                    } else {
                        // Unexpected response: server succeeded but provided no config data
                        let error = FetchAppConfigError.receivedNilResponseBody
                        logger.error("Failed to fetch app config from backend with error: \(error)")
                        completion?(error)
                    }
                case .failure(let error):
                    // Failure
                    logger.error("Failed to fetch app config from backend with error: \(error)")
                    completion?(error)
                }
            }
        }
    }

    private func updateAppConfigFromDisk() -> Bool {
        // Do nothing if no app config file is available
        guard jsonRepository.valueExists(name: appConfigFileName) else {
            logger.debug("No persisted app config found.")
            return false
        }
        // If a file exists, try to parse it
        do {
            backendConfig = try jsonRepository.read(AppConfig.self, name: appConfigFileName)
            logger.info("Restored persisted app config.")
            return true
        } catch {
            logger.error("Failed to restore persisted app config with error: \(error)")

            // If parsing fails, remove the corrupted file
            logger.debug("Removing corrupted app config file")
            do {
                try jsonRepository.removeValue(name: appConfigFileName)
                logger.debug("Removed app config file")
            } catch {
                logger.error("Failed to remove app config file with error: \(error)")
            }
            return false
        }
    }

    private func persistAppConfig(_ appConfig: AppConfig) {
        do {
            try jsonRepository.write(appConfig, name: appConfigFileName)
            logger.info("Persisted app config")
        } catch {
            logger.error("Failed to persist app config with error: \(error)")
        }
    }
}
