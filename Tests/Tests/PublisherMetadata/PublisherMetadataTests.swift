// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class PublisherMetadataTests: ChartboostCoreTestCase {
    let publisherMetadata = PublisherMetadata()

    /// Validates that all the setter methods just forward the information to the `publisherInfoProvider`.
    func testSetters() {
        publisherMetadata.setFramework(name: "framework name", version: "1234")
        XCTAssertEqual(mocks.publisherInfoProvider.frameworkName, "framework name")
        XCTAssertEqual(mocks.publisherInfoProvider.frameworkVersion, "1234")
        XCTAssertEqual(mocks.environmentChangePublisher.publishChangeCallCount, 2)
        // .frameworkName was called before .frameworkVersion
        XCTAssertEqual(mocks.environmentChangePublisher.publishChangeArguments.last, .frameworkVersion)

        publisherMetadata.setIsUserUnderage(false)
        XCTAssertEqual(mocks.publisherInfoProvider.isUserUnderage, false)
        XCTAssertEqual(mocks.environmentChangePublisher.publishChangeCallCount, 3)
        XCTAssertEqual(mocks.environmentChangePublisher.publishChangeArguments.last, .isUserUnderage)

        publisherMetadata.setPlayerID("some player ID 1234")
        XCTAssertEqual(mocks.publisherInfoProvider.playerID, "some player ID 1234")
        XCTAssertEqual(mocks.environmentChangePublisher.publishChangeCallCount, 4)
        XCTAssertEqual(mocks.environmentChangePublisher.publishChangeArguments.last, .playerID)

        publisherMetadata.setPublisherAppID("some publisher app ID 1234")
        XCTAssertEqual(mocks.publisherInfoProvider.publisherAppID, "some publisher app ID 1234")
        XCTAssertEqual(mocks.environmentChangePublisher.publishChangeCallCount, 5)
        XCTAssertEqual(mocks.environmentChangePublisher.publishChangeArguments.last, .publisherAppID)

        publisherMetadata.setPublisherSessionID("some publisher session ID 1234")
        XCTAssertEqual(mocks.publisherInfoProvider.publisherSessionID, "some publisher session ID 1234")
        XCTAssertEqual(mocks.environmentChangePublisher.publishChangeCallCount, 6)
        XCTAssertEqual(mocks.environmentChangePublisher.publishChangeArguments.last, .publisherSessionID)
    }
}
