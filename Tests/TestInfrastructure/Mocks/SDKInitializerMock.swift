// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class SDKInitializerMock: SDKInitializer {
    // MARK: - Call Counts and Return Values

    var initializeSDKCallCount = 0
    var initializeSDKConfigurationLastValue: SDKConfiguration?
    var initializeSDKModulesLastValue: [Module]?
    var initializeSDKModuleObserverLastValue: ModuleObserver?

    // MARK: - SDKInitializer

    func initializeSDK(configuration: SDKConfiguration, moduleObserver: ModuleObserver?) {
        initializeSDKCallCount += 1
        initializeSDKConfigurationLastValue = configuration
        initializeSDKModulesLastValue = configuration.modules
        initializeSDKModuleObserverLastValue = moduleObserver
    }
}
