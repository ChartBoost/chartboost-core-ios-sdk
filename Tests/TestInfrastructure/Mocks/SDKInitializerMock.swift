// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class SDKInitializerMock: SDKInitializer {

    // MARK: - Call Counts and Return Values

    var initializeSDKCallCount = 0
    var initializeSDKConfigurationLastValue: SDKConfiguration?
    var initializeSDKModulesLastValue: [InitializableModule]?
    var initializeSDKModuleObserverLastValue: InitializableModuleObserver?

    // MARK: - SDKInitializer

    func initializeSDK(
        with configuration: SDKConfiguration,
        modules: [InitializableModule],
        moduleObserver: InitializableModuleObserver?
    ) {
        initializeSDKCallCount += 1
        initializeSDKConfigurationLastValue = configuration
        initializeSDKModulesLastValue = modules
        initializeSDKModuleObserverLastValue = moduleObserver
    }
}
