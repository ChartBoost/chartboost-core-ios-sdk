// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class ChartboostCoreAppTrackingInfoProviderTests: ChartboostCoreTestCase {
    let provider = ChartboostCoreAppTrackingInfoProvider()

    /// Validates that all the provider properties can be accessed without crashing or warnings.
    /// Note that the actual values depend on the device under test and cannot be known in advance.
    func testAllValues() {
        _ = provider.appTrackingTransparencyStatus
        _ = provider.advertisingID
        _ = provider.isLimitAdTrackingEnabled
        _ = provider.vendorID

        // vendorIDScope is the only one for which we know the value in advance
        XCTAssertEqual(provider.vendorIDScope, .developer)
    }
}
