// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

extension AppConfigRequest.ResponseBody {

    static func build(
        isChildDirected: Bool? = true,
        coreInitializationDelayBaseMs: Int? = 2,
        maxCoreInitializationDelayMs: Int? = 3,
        maxCoreInitializationRetryCount: Int? = 4,
        moduleInitializationDelayBaseMs: Int? = 5,
        maxModuleInitializationDelayMs: Int? = 6,
        maxModuleInitializationRetryCount: Int? = 7,
        schemaVersion: String? = "some schema version",
        modules: [Module]? = []
    ) -> AppConfigRequest.ResponseBody {
        AppConfigRequest.ResponseBody(
            isChildDirected: isChildDirected,
            coreInitializationDelayBaseMs: coreInitializationDelayBaseMs,
            maxCoreInitializationDelayMs: maxCoreInitializationDelayMs,
            maxCoreInitializationRetryCount: maxCoreInitializationRetryCount,
            moduleInitializationDelayBaseMs: moduleInitializationDelayBaseMs,
            maxModuleInitializationDelayMs: maxModuleInitializationDelayMs,
            maxModuleInitializationRetryCount: maxModuleInitializationRetryCount,
            schemaVersion: schemaVersion,
            modules: modules
        )
    }
}
