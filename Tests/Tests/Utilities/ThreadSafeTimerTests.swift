// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ThreadSafeTimerTests: ChartboostCoreTestCase {

    /// Validates that a scheduled timer fires at the expected time.
    func testScheduledTimerFiresAtExpectedTime() {
        let expectation = self.expectation(description: "wait for timer to fire")
        let startDate = Date()
        let timer = ThreadSafeTimer.scheduledTimer(withTimeInterval: 0.5) { _ in
            XCTAssertGreaterThanOrEqual(Date(), startDate.addingTimeInterval(0.5))
            XCTAssertLessThan(Date(), startDate.addingTimeInterval(5))   // quite big error rate
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)

        // Read the timer variable to silence unused var warnings.
        // Note we need to hold to the timer otherwise it never fires.
        _ = timer
    }

    /// Validates that a scheduled timer does not fire if cancelled.
    func testScheduledTimerDoesNotFireIfCancelled() {
        let expectation = self.expectation(description: "wait for timer to fire")
        expectation.isInverted = true
        let timer = ThreadSafeTimer.scheduledTimer(withTimeInterval: 0.5) { _ in
            expectation.fulfill()
        }
        timer.cancel()
        waitForExpectations(timeout: 1)
    }
}
