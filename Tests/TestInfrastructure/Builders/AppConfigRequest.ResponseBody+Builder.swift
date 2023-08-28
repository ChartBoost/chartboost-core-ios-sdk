// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

extension AppConfigRequest.ResponseBody {

    static func build(
        isChildDirected: Bool? = true,
        coreInitializationDelayBaseMs: Int? = 2,
        coreInitializationDelayMaxMs: Int? = 3,
        coreInitializationRetryCountMax: Int? = 4,
        moduleInitializationDelayBaseMs: Int? = 5,
        moduleInitializationDelayMaxMs: Int? = 6,
        moduleInitializationRetryCountMax: Int? = 7,
        schemaVersion: String? = "some schema version",
        modules: [Module]? = []
    ) -> AppConfigRequest.ResponseBody {
        AppConfigRequest.ResponseBody(
            isChildDirected: isChildDirected,
            coreInitializationDelayBaseMs: coreInitializationDelayBaseMs,
            coreInitializationDelayMaxMs: coreInitializationDelayMaxMs,
            coreInitializationRetryCountMax: coreInitializationRetryCountMax,
            moduleInitializationDelayBaseMs: moduleInitializationDelayBaseMs,
            moduleInitializationDelayMaxMs: moduleInitializationDelayMaxMs,
            moduleInitializationRetryCountMax: moduleInitializationRetryCountMax,
            schemaVersion: schemaVersion,
            modules: modules
        )
    }
}
