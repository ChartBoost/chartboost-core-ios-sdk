// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

extension AppConfig {
    static func build(
        chartboostAppID: String? = "some app id",
        consentUpdateBatchDelay: TimeInterval = 0.5,
        coreInitializationDelayBase: TimeInterval = 5,
        coreInitializationDelayMax: TimeInterval = 5,
        coreInitializationRetryCountMax: Int = 5,
        moduleInitializationDelayMax: TimeInterval = 5,
        moduleInitializationRetryCountMax: Int = 5,
        moduleInitializationDelayBase: TimeInterval = 5,
        modules: [AppConfig.ModuleInfo] = []
    ) -> AppConfig {
        AppConfig(
            chartboostAppID: chartboostAppID,
            consentUpdateBatchDelay: consentUpdateBatchDelay,
            coreInitializationDelayBase: coreInitializationDelayBase,
            coreInitializationDelayMax: coreInitializationDelayMax,
            coreInitializationRetryCountMax: coreInitializationRetryCountMax,
            logLevelOverride: nil,
            moduleInitializationDelayBase: moduleInitializationDelayBase,
            moduleInitializationDelayMax: moduleInitializationDelayMax,
            moduleInitializationRetryCountMax: moduleInitializationRetryCountMax,
            modules: modules
        )
    }
}
