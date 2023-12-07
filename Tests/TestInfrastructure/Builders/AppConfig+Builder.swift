// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

extension AppConfig {

    static func build(
        coreInitializationDelayBase: TimeInterval = 5,
        coreInitializationDelayMax: TimeInterval = 5,
        coreInitializationRetryCountMax: Int = 5,
        moduleInitializationDelayMax: TimeInterval = 5,
        moduleInitializationRetryCountMax: Int = 5,
        moduleInitializationDelayBase: TimeInterval = 5,
        isChildDirected: Bool? = nil,
        modules: [AppConfig.ModuleInfo] = []
    ) -> AppConfig {
        AppConfig(
            coreInitializationDelayBase: coreInitializationDelayBase,
            coreInitializationDelayMax: coreInitializationDelayMax,
            coreInitializationRetryCountMax: coreInitializationRetryCountMax,
            moduleInitializationDelayBase: moduleInitializationDelayBase,
            moduleInitializationDelayMax: moduleInitializationDelayMax,
            moduleInitializationRetryCountMax: moduleInitializationRetryCountMax,
            isChildDirected: isChildDirected,
            modules: modules
        )
    }
}
