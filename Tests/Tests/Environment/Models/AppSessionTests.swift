// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class AppSessionTests: ChartboostCoreTestCase {
    /// Validates that session duration is a positive number with a value within a reasonable range.
    func testDuration() {
        let session = AppSession()
        wait(0.5)

        XCTAssertGreaterThan(session.duration, 0)
        XCTAssertLessThan(session.duration, 10)
    }
}
