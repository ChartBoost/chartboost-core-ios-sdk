// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class PublisherMetadataTests: ChartboostCoreTestCase {

    let publisherMetadata = PublisherMetadata()

    /// Validates that all the setter methods just forward the information to the `publisherInfoProvider`.
    func testSetters() {
        publisherMetadata.setFrameworkName("some framework name 1234")
        publisherMetadata.setFrameworkVersion("some framework version 1234")
        publisherMetadata.setIsUserUnderage(false)
        publisherMetadata.setPlayerID("some player ID 1234")
        publisherMetadata.setPublisherAppID("some publisher app ID 1234")
        publisherMetadata.setPublisherSessionID("some publisher session ID 1234")

        XCTAssertEqual(mocks.publisherInfoProvider.frameworkName, "some framework name 1234")
        XCTAssertEqual(mocks.publisherInfoProvider.frameworkVersion, "some framework version 1234")
        XCTAssertEqual(mocks.publisherInfoProvider.isUserUnderage, false)
        XCTAssertEqual(mocks.publisherInfoProvider.playerID, "some player ID 1234")
        XCTAssertEqual(mocks.publisherInfoProvider.publisherAppID, "some publisher app ID 1234")
        XCTAssertEqual(mocks.publisherInfoProvider.publisherSessionID, "some publisher session ID 1234")
    }
}
