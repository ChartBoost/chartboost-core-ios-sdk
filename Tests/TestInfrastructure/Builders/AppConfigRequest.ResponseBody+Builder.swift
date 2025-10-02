// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

extension AppConfigRequest.ResponseBody {
    static func build(
        consentUpdateBatchDelayMs: Int? = 5,
        coreInitializationDelayBaseMs: Int? = 2,
        coreInitializationDelayMaxMs: Int? = 3,
        coreInitializationRetryCountMax: Int? = 4,
        moduleInitializationDelayBaseMs: Int? = 5,
        moduleInitializationDelayMaxMs: Int? = 6,
        moduleInitializationRetryCountMax: Int? = 7,
        schemaVersion: String? = "some schema version",
        modules: [AppConfigRequest.ResponseBody.PlatformContainer.Module]? = []
    ) -> AppConfigRequest.ResponseBody {
        AppConfigRequest.ResponseBody(ios: .init(
            consentUpdateBatchDelayMs: consentUpdateBatchDelayMs,
            coreInitializationDelayBaseMs: coreInitializationDelayBaseMs,
            coreInitializationDelayMaxMs: coreInitializationDelayMaxMs,
            coreInitializationRetryCountMax: coreInitializationRetryCountMax,
            logLevel: "debug",
            moduleInitializationDelayBaseMs: moduleInitializationDelayBaseMs,
            moduleInitializationDelayMaxMs: moduleInitializationDelayMaxMs,
            moduleInitializationRetryCountMax: moduleInitializationRetryCountMax,
            schemaVersion: schemaVersion,
            modules: modules
        ))
    }
}
