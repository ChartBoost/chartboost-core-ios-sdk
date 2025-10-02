// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

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
