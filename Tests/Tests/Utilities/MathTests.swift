// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class MathTests: ChartboostCoreTestCase {
    /// Validates the retry delay interval formula.
    func testRetryDelayInterval() {
        XCTAssertEqual(
            (0...10).map {
                Math.retryDelayInterval(retryNumber: $0, base: 1.0, limit: 32)
            },
            [
                0.5,
                1.0,
                2.0,
                4.0,
                8.0,
                16.0,
                32.0,
                32.0,
                32.0,
                32.0,
                32.0,
            ]
        )
        XCTAssertEqual(
            (0...10).map {
                Math.retryDelayInterval(retryNumber: $0, base: 0.1, limit: 14)
            },
            [
                0.05,
                0.1,
                0.2,
                0.4,
                0.8,
                1.6,
                3.2,
                6.4,
                12.8,
                14.0,
                14.0,
            ]
        )
    }
}
