// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class ChartboostCoreAppConfigFactoryTests: ChartboostCoreTestCase {
    let factory = ChartboostCoreAppConfigFactory()

    /// Validates that a call to `makeAppConfig()` returns a config with the expected values when
    /// the response contains the full information.
    func testMakeAppConfigWithFullValues() {
        let response = AppConfigRequest.ResponseBody(ios: .init(
            consentUpdateBatchDelayMs: nil,
            coreInitializationDelayBaseMs: nil,
            coreInitializationDelayMaxMs: nil,
            coreInitializationRetryCountMax: nil,
            logLevel: "debug",
            moduleInitializationDelayBaseMs: nil,
            moduleInitializationDelayMaxMs: nil,
            moduleInitializationRetryCountMax: nil,
            schemaVersion: nil,
            modules: nil
        ))
        let fallbackValues = AppConfig(
            chartboostAppID: "abcde",
            consentUpdateBatchDelay: 123,
            coreInitializationDelayBase: 111,
            coreInitializationDelayMax: 222,
            coreInitializationRetryCountMax: 333,
            logLevelOverride: .debug,
            moduleInitializationDelayBase: 444,
            moduleInitializationDelayMax: 555,
            moduleInitializationRetryCountMax: 666,
            modules: [
                .init(
                    className: "some class name",
                    nonNativeClassName: nil,
                    identifier: "some identifier",
                    credentials: nil
                ),
                .init(
                    className: nil,
                    nonNativeClassName: "some class name 2",
                    identifier: "some identifier 2",
                    credentials: nil
                ),
            ]
        )

        let appConfig = factory.makeAppConfig(from: response, fallbackValues: fallbackValues, chartboostAppID: "abcde")

        XCTAssertEqual(appConfig, fallbackValues)
    }

    /// Validates that a call to `makeAppConfig()` returns a config with the expected values when
    /// the response contains partial information.
    func testMakeAppConfigWithFallbackValues() {
        let response = AppConfigRequest.ResponseBody(ios: .init(
            consentUpdateBatchDelayMs: 101,
            coreInitializationDelayBaseMs: 121,
            coreInitializationDelayMaxMs: 232,
            coreInitializationRetryCountMax: 343,
            logLevel: "debug",
            moduleInitializationDelayBaseMs: 454,
            moduleInitializationDelayMaxMs: 565,
            moduleInitializationRetryCountMax: 676,
            schemaVersion: "some schema version",
            modules: [
                .init(
                    className: "some class name 121",
                    nonNativeClassName: nil,
                    config: .init(
                        version: "some config version",
                        params: .init(value: ["some param": 20])
                    ),
                    id: "some identifier 121"
                ),
                .init(
                    className: nil,
                    nonNativeClassName: "some class name 232",
                    config: .init(
                        version: "some config version",
                        params: .init(value: ["some param": "some value"])
                    ),
                    id: "some identifier 232"
                ),
            ]
        ))
        let fallbackValues = AppConfig(
            chartboostAppID: "abcde",
            consentUpdateBatchDelay: 123,
            coreInitializationDelayBase: 111,
            coreInitializationDelayMax: 222,
            coreInitializationRetryCountMax: 333,
            logLevelOverride: .debug,
            moduleInitializationDelayBase: 444,
            moduleInitializationDelayMax: 555,
            moduleInitializationRetryCountMax: 666,
            modules: [
                .init(
                    className: "some class name",
                    nonNativeClassName: nil,
                    identifier: "some identifier",
                    credentials: nil
                ),
                .init(
                    className: "some class name 2",
                    nonNativeClassName: nil,
                    identifier: "some identifier 2",
                    credentials: nil
                ),
            ]
        )

        let appConfig = factory.makeAppConfig(from: response, fallbackValues: fallbackValues, chartboostAppID: "abcde")

        XCTAssertEqual(
            appConfig,
            AppConfig(
                chartboostAppID: "abcde",
                consentUpdateBatchDelay: 0.101,
                coreInitializationDelayBase: 0.121,
                coreInitializationDelayMax: 0.232,
                coreInitializationRetryCountMax: 343,
                logLevelOverride: .debug,
                moduleInitializationDelayBase: 0.454,
                moduleInitializationDelayMax: 0.565,
                moduleInitializationRetryCountMax: 676,
                modules: [
                    .init(
                        className: "some class name 121",
                        nonNativeClassName: nil,
                        identifier: "some identifier 121",
                        credentials: JSON(value: ["some param": 20])
                    ),
                    .init(
                        className: nil,
                        nonNativeClassName: "some class name 232",
                        identifier: "some identifier 232",
                        credentials: JSON(value: ["some param": "some value"])
                    ),
                ]
            )
        )
    }
}
