// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ChartboostCorePublisherInfoProviderTests: ChartboostCoreTestCase {

    let provider = ChartboostCorePublisherInfoProvider()

    /// Validates that all the provider properties have proper values
    func testAllValues() {
        // Check that app version matches value from Info.plist
        mocks.infoPlist.appVersion = "1.2.3"
        XCTAssertEqual(provider.appVersion, "1.2.3")

        // Check that accessing bundle ID does not crash or raise warnings
        _ = provider.bundleID

        // Check default values for other properties
        XCTAssertNil(provider.frameworkVersion)
        XCTAssertFalse(provider.isUserUnderage)
        XCTAssertNil(provider.playerID)
        XCTAssertNil(provider.publisherAppID)
        XCTAssertNil(provider.publisherSessionID)

        // Check setting values for these properties
        provider.frameworkVersion = "frameworkVersion"
        provider.isUserUnderage = true
        provider.playerID = "playerID"
        provider.publisherAppID = "publisherAppID"
        provider.publisherSessionID = "publisherSessionID"

        XCTAssertEqual(provider.frameworkVersion, "frameworkVersion")
        XCTAssertEqual(provider.isUserUnderage, true)
        XCTAssertEqual(provider.playerID, "playerID")
        XCTAssertEqual(provider.publisherAppID, "publisherAppID")
        XCTAssertEqual(provider.publisherSessionID, "publisherSessionID")
    }
}
