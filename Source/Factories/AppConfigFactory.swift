// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Factory to create an ``AppConfig`` model from an app config backend response.
protocol AppConfigFactory {
    /// Returns a ``AppConfig`` using the values obtained from a backend response.
    /// - parameter response: The backend response with the values to be used.
    /// - parameter fallbackValue: The values to use when the corresponding backend ones are ommited.
    /// - parameter chartboostAppID: The associated Chartboost App ID used to retrieve the response.
    func makeAppConfig(
        from response: AppConfigRequest.ResponseBody,
        fallbackValues: AppConfig,
        chartboostAppID: String
    ) -> AppConfig
}

/// Core's concrete implementation of ``AppConfigFactory``.
struct ChartboostCoreAppConfigFactory: AppConfigFactory {
    // swiftlint:disable line_length
    func makeAppConfig(
        from response: AppConfigRequest.ResponseBody,
        fallbackValues: AppConfig,
        chartboostAppID: String
    ) -> AppConfig {
        AppConfig(
            chartboostAppID: chartboostAppID,
            consentUpdateBatchDelay: asTimeInterval(response.ios?.consentUpdateBatchDelayMs) ?? fallbackValues.consentUpdateBatchDelay,
            coreInitializationDelayBase: asTimeInterval(response.ios?.coreInitializationDelayBaseMs) ?? fallbackValues.coreInitializationDelayBase,
            coreInitializationDelayMax: asTimeInterval(response.ios?.coreInitializationDelayMaxMs) ?? fallbackValues.coreInitializationDelayMax,
            coreInitializationRetryCountMax: response.ios?.coreInitializationRetryCountMax ?? fallbackValues.coreInitializationRetryCountMax,
            logLevelOverride: LogLevel(string: response.ios?.logLevel ?? ""),
            moduleInitializationDelayBase: asTimeInterval(response.ios?.moduleInitializationDelayBaseMs) ?? fallbackValues.moduleInitializationDelayBase,
            moduleInitializationDelayMax: asTimeInterval(response.ios?.moduleInitializationDelayMaxMs) ?? fallbackValues.moduleInitializationDelayMax,
            moduleInitializationRetryCountMax: response.ios?.moduleInitializationRetryCountMax ?? fallbackValues.moduleInitializationRetryCountMax,
            modules: response.ios?.modules?.map {
                AppConfig.ModuleInfo(
                    className: $0.className,
                    nonNativeClassName: $0.nonNativeClassName,
                    identifier: $0.id,
                    credentials: $0.config?.params
                )
            } ?? fallbackValues.modules
        )
    }
    // swiftlint:enable line_length

    private func asTimeInterval(_ valueInMilliseconds: Int?) -> TimeInterval? {
        valueInMilliseconds.map { Double($0) / 1000.0 }
    }
}
