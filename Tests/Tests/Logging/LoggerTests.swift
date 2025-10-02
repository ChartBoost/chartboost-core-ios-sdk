// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class LoggerTests: ChartboostCoreTestCase {
    /// Validates that the console logger log methods create a log entry and forward it to the handlers.
    func testLog() {
        let parentLogger = Logger(id: "parent", name: "Parent Category")
        let childLogger = Logger(id: "child", name: "Child Category", parent: parentLogger)
        let handler1 = LogHandlerMock()
        let handler2 = LogHandlerMock()

        parentLogger.attachHandler(handler1)
        childLogger.attachHandler(handler2)

        func assertLogReceived(message: String, level: LogLevel) {
            XCTAssertEqual(handler1.handleCallCount, 1)
            XCTAssertEqual(handler1.handleArguments.last?.message, message)
            XCTAssertEqual(handler1.handleArguments.last?.logLevel, level)
            XCTAssertEqual(handler1.handleArguments.last?.subsystem, "parent.child")
            XCTAssertEqual(handler1.handleArguments.last?.category, "Child Category")
            handler1.handleCallCount = 0

            XCTAssertEqual(handler2.handleCallCount, 1)
            XCTAssertEqual(handler2.handleArguments.last?.message, message)
            XCTAssertEqual(handler2.handleArguments.last?.logLevel, level)
            XCTAssertEqual(handler2.handleArguments.last?.subsystem, "parent.child")
            XCTAssertEqual(handler2.handleArguments.last?.category, "Child Category")
            handler2.handleCallCount = 0
        }

        // Test log level-specific methods.
        childLogger.error("some message 1")
        waitForTasksDispatchedOnBackgroundQueue()
        assertLogReceived(message: "some message 1", level: .error)

        childLogger.warning("some message 2")
        waitForTasksDispatchedOnBackgroundQueue()
        assertLogReceived(message: "some message 2", level: .warning)

        childLogger.verbose("some message 3")
        waitForTasksDispatchedOnBackgroundQueue()
        assertLogReceived(message: "some message 3", level: .verbose)

        childLogger.debug("some message 4")
        waitForTasksDispatchedOnBackgroundQueue()
        assertLogReceived(message: "some message 4", level: .debug)

        childLogger.info("some message 5")
        waitForTasksDispatchedOnBackgroundQueue()
        assertLogReceived(message: "some message 5", level: .info)

        // Test generic log method
        childLogger.log("some message", level: .warning)
        waitForTasksDispatchedOnBackgroundQueue()
        assertLogReceived(message: "some message", level: .warning)

        // Test detach
        childLogger.detachHandler(handler2)

        childLogger.info("some message")
        waitForTasksDispatchedOnBackgroundQueue()
        XCTAssertEqual(handler2.handleCallCount, 0)
    }
}
