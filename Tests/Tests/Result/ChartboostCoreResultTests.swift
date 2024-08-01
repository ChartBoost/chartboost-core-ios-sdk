// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class ChartboostCoreResultTests: XCTestCase {
    /// Validates that init creates an object with the appropriate values.
    func testInit() {
        let startDate = Date(timeIntervalSinceNow: -30)
        let endDate = Date(timeIntervalSinceNow: 2.5)
        let error = NSError(domain: "", code: 2, userInfo: nil)

        let result = ChartboostCoreResult(startDate: startDate, endDate: endDate, error: error)

        XCTAssertEqual(result.startDate, startDate)
        XCTAssertEqual(result.endDate, endDate)
        XCTAssertIdentical(result.error as? NSError, error)
        XCTAssertEqual(result.duration, endDate.timeIntervalSince(startDate))
    }
}
