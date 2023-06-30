// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

protocol SDKInitializer {
    func initializeSDK(
        with configuration: SDKConfiguration,
        modules: [InitializableModule],
        moduleObserver: InitializableModuleObserver?,
        completion: @escaping (_ result: SDKInitializationResult) -> Void
    )
}

final class ChartboostCoreSDKInitializer: SDKInitializer {

    @Injected(\.userAgentProvider) private var userAgentProvider
    @Injected(\.sessionInfoProvider) private var sessionInfoProvider

    func initializeSDK(
        with configuration: SDKConfiguration,
        modules: [InitializableModule],
        moduleObserver: InitializableModuleObserver?,
        completion: @escaping (_ result: SDKInitializationResult) -> Void
    ) {
        // TODO: Implemement
        
        userAgentProvider.updateUserAgent()

        modules.forEach { module in
            // implementation
        }

        sessionInfoProvider.reset() // TODO: Only if session not yet started

        let result = SDKInitializationResult(startDate: Date(), error: nil, isSDKInitialized: false)
        completion(result)
    }
}
