// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class LoggerTests: ChartboostCoreTestCase {

    /// Validates that the console logger log methods create a log entry and forward it to the handlers.
    func testLog() {
        let logger = Logger(subsystem: "some subsystem", category: "some category")
        let handler = LogHandlerMock()

        Logger.attachHandler(handler)

        func assertLogReceived(message: String, level: LogLevel) {
            XCTAssertEqual(handler.handleCallCount, 1)
            XCTAssertEqual(handler.handleEntryLastValue?.message, message)
            XCTAssertEqual(handler.handleEntryLastValue?.logLevel, level)
            XCTAssertEqual(handler.handleEntryLastValue?.subsystem, "some subsystem")
            XCTAssertEqual(handler.handleEntryLastValue?.category, "some category")
            handler.handleCallCount = 0
        }

        // Test log level-specific methods.
        logger.error("some message 1")
        waitForTasksDispatchedOnBackgroundQueue()
        assertLogReceived(message: "some message 1", level: .error)

        logger.warning("some message 2")
        waitForTasksDispatchedOnBackgroundQueue()
        assertLogReceived(message: "some message 2", level: .warning)

        logger.trace("some message 3")
        waitForTasksDispatchedOnBackgroundQueue()
        assertLogReceived(message: "some message 3", level: .trace)

        logger.debug("some message 4")
        waitForTasksDispatchedOnBackgroundQueue()
        assertLogReceived(message: "some message 4", level: .debug)

        logger.info("some message 5")
        waitForTasksDispatchedOnBackgroundQueue()
        assertLogReceived(message: "some message 5", level: .info)

        // Test generic log method
        logger.log("some message", level: .warning)
        waitForTasksDispatchedOnBackgroundQueue()
        assertLogReceived(message: "some message", level: .warning)

        // Test detach
        Logger.detachHandler(handler)

        logger.info("some message")
        waitForTasksDispatchedOnBackgroundQueue()
        XCTAssertEqual(handler.handleCallCount, 0)
    }
}
