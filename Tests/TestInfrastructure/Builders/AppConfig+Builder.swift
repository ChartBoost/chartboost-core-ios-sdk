// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

extension AppConfig {

    static func build(
        coreInitializationDelayBase: TimeInterval = 5,
        maxCoreInitializationDelay: TimeInterval = 5,
        maxCoreInitializationRetryCount: Int = 5,
        maxModuleInitializationDelay: TimeInterval = 5,
        maxModuleInitializationRetryCount: Int = 5,
        moduleInitializationDelayBase: TimeInterval = 5,
        isChildDirected: Bool? = nil,
        modules: [AppConfig.ModuleInfo] = []
    ) -> AppConfig {
        AppConfig(
            coreInitializationDelayBase: coreInitializationDelayBase,
            maxCoreInitializationDelay: maxCoreInitializationDelay,
            maxCoreInitializationRetryCount: maxCoreInitializationRetryCount,
            maxModuleInitializationDelay: maxModuleInitializationDelay,
            maxModuleInitializationRetryCount: maxModuleInitializationRetryCount,
            moduleInitializationDelayBase: moduleInitializationDelayBase,
            isChildDirected: isChildDirected,
            modules: modules
        )
    }
}
