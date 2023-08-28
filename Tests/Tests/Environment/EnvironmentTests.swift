// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class EnvironmentTests: ChartboostCoreTestCase {

    /// Validates that the values for all properties are properly sourced from the corresponding info providers.
    func testAllValuesMatchInfoProviders() {
        let environment = Environment(purpose: .analytics)

        XCTAssertEqual(environment.appTrackingTransparencyStatus, mocks.appTrackingInfoProvider.appTrackingTransparencyStatus)
        XCTAssertGreaterThanOrEqual(environment.appSessionDuration, (mocks.sessionInfoProvider.session?.duration ?? 0) - 0.5)
        XCTAssertLessThanOrEqual(environment.appSessionDuration, (mocks.sessionInfoProvider.session?.duration ?? 0) + 0.5)
        XCTAssertEqual(environment.appSessionID, mocks.sessionInfoProvider.session?.identifier)
        XCTAssertEqual(environment.appVersion, mocks.publisherInfoProvider.appVersion)
        XCTAssertEqual(environment.advertisingID, mocks.appTrackingInfoProvider.advertisingID)
        XCTAssertEqual(environment.bundleID, mocks.publisherInfoProvider.bundleID)
        XCTAssertEqual(environment.deviceLocale, mocks.deviceInfoProvider.deviceLocale)
        XCTAssertEqual(environment.deviceMake, mocks.deviceInfoProvider.make)
        XCTAssertEqual(environment.deviceModel, mocks.deviceInfoProvider.model)
        XCTAssertEqual(environment.frameworkName, mocks.publisherInfoProvider.frameworkName)
        XCTAssertEqual(environment.frameworkVersion, mocks.publisherInfoProvider.frameworkVersion)
        XCTAssertEqual(environment.isLimitAdTrackingEnabled, mocks.appTrackingInfoProvider.isLimitAdTrackingEnabled)
        XCTAssertEqual(environment.isUserUnderage, mocks.publisherInfoProvider.isUserUnderage)
        XCTAssertEqual(environment.networkConnectionType, mocks.networkConnectionTypeProvider.connectionType)
        XCTAssertEqual(environment.osName, mocks.deviceInfoProvider.osName)
        XCTAssertEqual(environment.osVersion, mocks.deviceInfoProvider.osVersion)
        XCTAssertEqual(environment.playerID, mocks.publisherInfoProvider.playerID)
        XCTAssertEqual(environment.publisherAppID, mocks.publisherInfoProvider.publisherAppID)
        XCTAssertEqual(environment.publisherSessionID, mocks.publisherInfoProvider.publisherSessionID)
        XCTAssertEqual(environment.screenHeight, mocks.deviceInfoProvider.screenHeight)
        XCTAssertEqual(environment.screenScale, mocks.deviceInfoProvider.screenScale)
        XCTAssertEqual(environment.screenWidth, mocks.deviceInfoProvider.screenWidth)
        XCTAssertEqual(environment.vendorID, mocks.appTrackingInfoProvider.vendorID)
        XCTAssertEqual(environment.vendorIDScope, mocks.appTrackingInfoProvider.vendorIDScope)
        XCTAssertEqual(environment.volume, mocks.deviceInfoProvider.volume)

        let expectation = expectation(description: "wait for fetch user agent")
        environment.userAgent { [self] userAgent in
            self.mocks.userAgentProvider.userAgent { [userAgent] anotherUserAgent in
                XCTAssertEqual(userAgent, anotherUserAgent)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10)
    }

    /// Validates that the IFA value is not provided if the user is underage, unless for the purpose of analytics.
    func testAdvertisingIDIsGatedByUnderageStatus() {
        mocks.appTrackingInfoProvider.advertisingID = "1234"

        // Not gated for analytics
        mocks.publisherInfoProvider.isUserUnderage = true
        XCTAssertEqual(Environment(purpose: .analytics).advertisingID, "1234")

        // Not gated if not underage
        mocks.publisherInfoProvider.isUserUnderage = false
        mocks.appConfigRepository.config = .build(isChildDirected: false)
        XCTAssertEqual(Environment(purpose: .advertising).advertisingID, "1234")
        XCTAssertEqual(Environment(purpose: .attribution).advertisingID, "1234")

        // Not gated if not underage (backend signal nil)
        mocks.publisherInfoProvider.isUserUnderage = false
        mocks.appConfigRepository.config = .build(isChildDirected: nil)
        XCTAssertEqual(Environment(purpose: .advertising).advertisingID, "1234")
        XCTAssertEqual(Environment(purpose: .attribution).advertisingID, "1234")

        // Gated if underage (publisher signal)
        mocks.publisherInfoProvider.isUserUnderage = true
        mocks.appConfigRepository.config = .build(isChildDirected: false)
        XCTAssertNil(Environment(purpose: .advertising).advertisingID)
        XCTAssertNil(Environment(purpose: .attribution).advertisingID)

        // Gated if underage (publisher signal, backend nil)
        mocks.publisherInfoProvider.isUserUnderage = true
        mocks.appConfigRepository.config = .build(isChildDirected: nil)
        XCTAssertNil(Environment(purpose: .advertising).advertisingID)
        XCTAssertNil(Environment(purpose: .attribution).advertisingID)

        // Gated if underage (backend signal)
        mocks.publisherInfoProvider.isUserUnderage = false
        mocks.appConfigRepository.config = .build(isChildDirected: true)
        XCTAssertNil(Environment(purpose: .advertising).advertisingID)
        XCTAssertNil(Environment(purpose: .attribution).advertisingID)

        // Gated if underage (both signals)
        mocks.publisherInfoProvider.isUserUnderage = true
        mocks.appConfigRepository.config = .build(isChildDirected: true)
        XCTAssertNil(Environment(purpose: .advertising).advertisingID)
        XCTAssertNil(Environment(purpose: .attribution).advertisingID)
    }

    /// Validates that the value for `appSessionDuration` is 0 if Core has not been tried to initialize yet.
    func testAppSessionDurationIsZeroIfNoSession() {
        mocks.sessionInfoProvider.session = nil
        XCTAssertEqual(Environment(purpose: .analytics).appSessionDuration, 0)
    }
}
