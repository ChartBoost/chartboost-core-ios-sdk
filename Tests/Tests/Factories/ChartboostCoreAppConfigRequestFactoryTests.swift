// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ChartboostCoreAppConfigRequestFactoryTests: ChartboostCoreTestCase {

    let factory = ChartboostCoreAppConfigRequestFactory()

    /// Validates that a call to `makeRequest()` returns a request with the expected values.
    func testMakeRequest() {
        let configuration = SDKConfiguration(chartboostAppID: "some app id")
        let environment = EnvironmentMock()

        let request = factory.makeRequest(configuration: configuration, environment: environment)

        XCTAssertEqual(request.body?.configuration.app.bundleId, environment.bundleID)
        XCTAssertEqual(request.body?.configuration.app.publisherApplicationIdentifier, environment.publisherAppID)
        XCTAssertEqual(request.body?.configuration.app.version, environment.appVersion)
        XCTAssertEqual(request.body?.configuration.chartboostApplicationIdentifier, "some app id")
        XCTAssertEqual(request.body?.configuration.coreVersion, ChartboostCore.sdkVersion)
        XCTAssertEqual(request.body?.configuration.framework.name, environment.frameworkName)
        XCTAssertEqual(request.body?.configuration.framework.version, environment.osVersion)
        XCTAssertEqual(request.body?.configuration.player.playerId, environment.playerID)
        XCTAssertEqual(request.body?.configuration.schemaVersion, "1.0")
        XCTAssertEqual(request.body?.configuration.vendor.identifier, environment.vendorID)
        XCTAssertEqual(request.body?.configuration.vendor.scope, environment.vendorIDScope.description)
        XCTAssertEqual(request.body?.device.locale, environment.deviceLocale)
        XCTAssertEqual(request.body?.device.network.connectionType, environment.networkConnectionType.description)
        XCTAssertEqual(request.body?.device.os.name, environment.osName)
        XCTAssertEqual(request.body?.device.os.version, environment.osVersion)
        XCTAssertEqual(request.body?.device.screen.height, Int(environment.screenHeight))
        XCTAssertEqual(request.body?.device.screen.width, Int(environment.screenWidth))
        XCTAssertEqual(request.body?.device.screen.scale, environment.screenScale)
        XCTAssertEqual(request.body?.device.specifications.make, environment.deviceMake)
        XCTAssertEqual(request.body?.device.specifications.model, environment.deviceModel)
    }
}
