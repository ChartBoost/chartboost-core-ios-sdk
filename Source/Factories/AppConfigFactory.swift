// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Factory to create an ``AppConfig`` model from an app config backend response.
protocol AppConfigFactory {

    /// Returns a ``AppConfig`` using the values obtained from a backend response.
    /// - parameter response: The backend response with the values to be used.
    /// - parameter fallbackValue: The values to use when the corresponding backend ones are ommited.
    func makeAppConfig(from response: AppConfigRequest.ResponseBody, fallbackValues: AppConfig) -> AppConfig
}

/// Core's concrete implementation of ``AppConfigFactory``.
struct ChartboostCoreAppConfigFactory: AppConfigFactory {

    func makeAppConfig(from response: AppConfigRequest.ResponseBody, fallbackValues: AppConfig) -> AppConfig {
        AppConfig(
            coreInitializationDelayBase: asTimeInterval(response.coreInitializationDelayBaseMs) ?? fallbackValues.coreInitializationDelayBase,
            coreInitializationDelayMax: asTimeInterval(response.coreInitializationDelayMaxMs) ?? fallbackValues.coreInitializationDelayMax,
            coreInitializationRetryCountMax: response.coreInitializationRetryCountMax ?? fallbackValues.coreInitializationRetryCountMax,
            moduleInitializationDelayBase: asTimeInterval(response.moduleInitializationDelayBaseMs) ?? fallbackValues.moduleInitializationDelayBase,
            moduleInitializationDelayMax: asTimeInterval(response.moduleInitializationDelayMaxMs) ?? fallbackValues.moduleInitializationDelayMax,
            moduleInitializationRetryCountMax: response.moduleInitializationRetryCountMax ?? fallbackValues.moduleInitializationRetryCountMax,
            isChildDirected: response.isChildDirected ?? fallbackValues.isChildDirected,
            modules: response.modules?.map {
                AppConfig.ModuleInfo(
                    className: $0.className,
                    identifier: $0.id,
                    credentials: $0.config.params)
            } ?? fallbackValues.modules
        )
    }

    private func asTimeInterval(_ valueInMilliseconds: Int?) -> TimeInterval? {
        valueInMilliseconds.map { Double($0) / 1000.0 }
    }
}
