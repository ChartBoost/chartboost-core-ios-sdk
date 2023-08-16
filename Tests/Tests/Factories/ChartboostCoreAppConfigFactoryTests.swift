// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ChartboostCoreAppConfigFactoryTests: ChartboostCoreTestCase {

    let factory = ChartboostCoreAppConfigFactory()

    /// Validates that a call to `makeAppConfig()` returns a config with the expected values when
    /// the response contains the full information.
    func testMakeAppConfigWithFullValues() {
        let response = AppConfigRequest.ResponseBody(
            isChildDirected: nil,
            coreInitializationDelayBaseMs: nil,
            maxCoreInitializationDelayMs: nil,
            maxCoreInitializationRetryCount: nil,
            moduleInitializationDelayBaseMs: nil,
            maxModuleInitializationDelayMs: nil,
            maxModuleInitializationRetryCount: nil,
            schemaVersion: nil,
            modules: nil
        )
        let fallbackValues = AppConfig(
            coreInitializationDelayBase: 111,
            maxCoreInitializationDelay: 222,
            maxCoreInitializationRetryCount: 333,
            maxModuleInitializationDelay: 444,
            maxModuleInitializationRetryCount: 555,
            moduleInitializationDelayBase: 666,
            isChildDirected: true,
            modules: [
                .init(
                    className: "some class name",
                    identifier: "some identifier",
                    credentials: nil
                ),
                .init(
                    className: "some class name 2",
                    identifier: "some identifier 2",
                    credentials: nil
                )
            ]
        )

        let appConfig = factory.makeAppConfig(from: response, fallbackValues: fallbackValues)

        XCTAssertEqual(appConfig, fallbackValues)
    }

    /// Validates that a call to `makeAppConfig()` returns a config with the expected values when
    /// the response contains partial information.
    func testMakeAppConfigWithFallbackValues() {
        let response = AppConfigRequest.ResponseBody(
            isChildDirected: false,
            coreInitializationDelayBaseMs: 121,
            maxCoreInitializationDelayMs: 232,
            maxCoreInitializationRetryCount: 343,
            moduleInitializationDelayBaseMs: 454,
            maxModuleInitializationDelayMs: 565,
            maxModuleInitializationRetryCount: 676,
            schemaVersion: "some schema version",
            modules: [
                .init(
                    className: "some class name 121",
                    config: .init(
                        version: "some config version",
                        params: .init(value: ["some param": 20])
                    ),
                    id: "some identifier 121"
                ),
                .init(
                    className: "some class name 232",
                    config: .init(
                        version: "some config version",
                        params: .init(value: ["some param": "some value"])
                    ),
                    id: "some identifier 232"
                )
            ]
        )
        let fallbackValues = AppConfig(
            coreInitializationDelayBase: 111,
            maxCoreInitializationDelay: 222,
            maxCoreInitializationRetryCount: 333,
            maxModuleInitializationDelay: 444,
            maxModuleInitializationRetryCount: 555,
            moduleInitializationDelayBase: 666,
            isChildDirected: true,
            modules: [
                .init(
                    className: "some class name",
                    identifier: "some identifier",
                    credentials: nil
                ),
                .init(
                    className: "some class name 2",
                    identifier: "some identifier 2",
                    credentials: nil
                )
            ]
        )

        let appConfig = factory.makeAppConfig(from: response, fallbackValues: fallbackValues)

        XCTAssertEqual(
            appConfig,
            AppConfig(
                coreInitializationDelayBase: 0.121,
                maxCoreInitializationDelay: 0.232,
                maxCoreInitializationRetryCount: 343,
                maxModuleInitializationDelay: 0.565,
                maxModuleInitializationRetryCount: 676,
                moduleInitializationDelayBase: 0.454,
                isChildDirected: false,
                modules: [
                    .init(
                        className: "some class name 121",
                        identifier: "some identifier 121",
                        credentials: JSON(value: ["some param": 20])
                    ),
                    .init(
                        className: "some class name 232",
                        identifier: "some identifier 232",
                        credentials: JSON(value: ["some param": "some value"])
                    )
                ]
            )
        )
    }
}
