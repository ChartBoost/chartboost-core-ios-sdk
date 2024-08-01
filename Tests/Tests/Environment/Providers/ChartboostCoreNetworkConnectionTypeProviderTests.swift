// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class ChartboostCoreNetworkConnectionTypeProviderTests: ChartboostCoreTestCase {
    let provider = ChartboostCoreNetworkConnectionTypeProvider()

    /// Validates that the connectionType value is properly computed when network status is unknown.
    func testConnectionTypeWithNetworkStatusUnknown() {
        mocks.networkStatusProvider.status = .unknown

        XCTAssertEqual(provider.connectionType, .unknown)
    }

    /// Validates that the connectionType value is properly computed when network status is notReachable.
    func testConnectionTypeWithNetworkStatusNotReachable() {
        mocks.networkStatusProvider.status = .notReachable

        XCTAssertEqual(provider.connectionType, .unknown)
    }

    /// Validates that the connectionType value is properly computed when network status is reachableViaWiFi.
    func testConnectionTypeWithNetworkStatusReachableViaWiFi() {
        mocks.networkStatusProvider.status = .reachableViaWiFi

        XCTAssertEqual(provider.connectionType, .wifi)
    }

    /// Validates that the connectionType value is properly computed when network status is reachableViaWWAN.
    func testConnectionTypeWithNetworkStatusReachableViaWWAN() {
        mocks.networkStatusProvider.status = .reachableViaWWAN

        // The final value depends on the info provided by CTTelephonyNetworkInfo.
        // For simplicity we just check that it is one of the expected values.
        XCTAssertTrue(
            provider.connectionType == .cellular2G
            || provider.connectionType == .cellular3G
            || provider.connectionType == .cellular4G
            || provider.connectionType == .cellular5G
            || provider.connectionType == .cellularUnknown
        )
    }
}
