// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class LogEntryTests: ChartboostCoreTestCase {

    /// Validates that the init assigns expected values to all the properties.
    func testInit() {
        let entry = LogEntry(
            message: "some message",
            subsystem: "some subsystem",
            category: "some category",
            logLevel: .warning
        )

        XCTAssertEqual(entry.message, "some message")
        XCTAssertEqual(entry.subsystem, "some subsystem")
        XCTAssertEqual(entry.category, "some category")
        XCTAssertEqual(entry.logLevel, .warning)
        XCTAssertLessThanOrEqual(entry.date, Date())
        XCTAssertGreaterThanOrEqual(entry.date, Date().advanced(by: -1))
    }
}
