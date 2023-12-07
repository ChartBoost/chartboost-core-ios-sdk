// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class SDKConfigurationTests: ChartboostCoreTestCase {

    /// Validates that the class init instantiates an object with the expected values.
    func testInit() {
        let configuration = SDKConfiguration(chartboostAppID: "some app id")
        XCTAssertEqual(configuration.chartboostAppID, "some app id")
    }
}
