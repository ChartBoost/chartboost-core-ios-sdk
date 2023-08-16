// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ChartboostCoreUserAgentProviderTests: ChartboostCoreTestCase {

    let provider = ChartboostCoreUserAgentProvider()

    /// Validates that initially there is no user agent.
    func testInitialValues() {
        XCTAssertNil(provider.userAgent)
    }

    /// Validates that calling `updateUserAgent()` fetches a new user agent.
    func testUpdateUserAgent() {
        provider.updateUserAgent()

        func assertUserAgentIsNotNil() {
            XCTAssertNotNil(provider.userAgent)
        }

        // Check if user agent was retrieved in a short time, in an effort to minimize the test time.
        wait(0.5)
        if provider.userAgent == nil {
            // If user agent was not retrieved, try again in 2 seconds
            wait(2)
        }
        if provider.userAgent == nil {
            // If user agent is still not retrieved, try again in a long time
            wait(10)
        }

        XCTAssertNotNil(provider.userAgent)
    }
}
