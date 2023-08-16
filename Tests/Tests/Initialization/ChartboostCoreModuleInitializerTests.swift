// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ChartboostCoreModuleInitializerTests: ChartboostCoreTestCase {

    let module = InitializableModuleMock()

    lazy var repository = ChartboostCoreModuleInitializer(
        module: module,
        queue: .main
    )

    /// Validates a `initialize()` call completes successfully if the module succeeds.
    func testInitializeIfModuleSucceeds() {
        let expectation = self.expectation(description: "wait for module initialization")
        let startDate = Date()

        repository.initialize { result in
            // Check that the result is successful
            self.assertResultHasExpectedInfo(result, error: nil, startDate: startDate)
            expectation.fulfill()
        }

        // Check that the module was asked to initialize
        XCTAssertEqual(module.initializeCallCount, 1)

        // Trigger module initialization completion with success
        module.initializeCompletionLastValue?(nil)

        // The the initialize() completion should be executed at this point
        waitForExpectations(timeout: 5)
    }

    /// Validates a `initialize()` call completes with an error if the module fails all retries.
    func testInitializeIfModuleFailsAllRetries() {
        // Set short retry values so the test runs quicker
        mocks.appConfigRepository.config = .build(
            maxModuleInitializationDelay: 1,
            maxModuleInitializationRetryCount: 3,
            moduleInitializationDelayBase: 0.1
        )

        let expectation = self.expectation(description: "wait for module initialization")
        let startDate = Date()
        let expectedError = NSError(domain: "module error", code: 8472)

        repository.initialize { result in
            // Check that the result is a failure
            self.assertResultHasExpectedInfo(result, error: expectedError, startDate: startDate)
            expectation.fulfill()
        }

        // Check that the module was asked to initialize
        XCTAssertEqual(module.initializeCallCount, 1)
        // Trigger module initialization completion with an error
        module.initializeCompletionLastValue?(NSError(domain: "", code: 3))
        // Wait a short amount of time for the retry to trigger
        wait(0.5)

        // Check that the module was asked to initialize again
        XCTAssertEqual(module.initializeCallCount, 2)
        // Trigger module initialization completion with an error
        module.initializeCompletionLastValue?(NSError(domain: "", code: 3))
        // Wait a short amount of time for the retry to trigger
        wait(0.5)

        // Check that the module was asked to initialize again
        XCTAssertEqual(module.initializeCallCount, 3)
        // Trigger module initialization completion with an error
        module.initializeCompletionLastValue?(NSError(domain: "", code: 3))
        // Wait a short amount of time for the retry to trigger
        wait(0.5)

        // Check that the module was asked to initialize again
        XCTAssertEqual(module.initializeCallCount, 4)
        // Trigger module initialization completion with an error
        module.initializeCompletionLastValue?(expectedError)

        // The the initialize() completion should be executed at this point
        waitForExpectations(timeout: 5)
    }

    /// Validates a `initialize()` call completes successfully if the module succeeds on a retry.
    func testInitializeIfModuleSucceedsOnARetry() {
        // Set short retry values so the test runs quicker
        mocks.appConfigRepository.config = .build(
            maxModuleInitializationDelay: 1,
            maxModuleInitializationRetryCount: 3,
            moduleInitializationDelayBase: 0.1
        )

        let expectation = self.expectation(description: "wait for module initialization")
        let startDate = Date()

        repository.initialize { result in
            // Check that the result is a failure
            self.assertResultHasExpectedInfo(result, error: nil, startDate: startDate)
            expectation.fulfill()
        }

        // Check that the module was asked to initialize
        XCTAssertEqual(module.initializeCallCount, 1)
        // Trigger module initialization completion with an error
        module.initializeCompletionLastValue?(NSError(domain: "", code: 3))
        // Wait a short amount of time for the retry to trigger
        wait(0.5)

        // Check that the module was asked to initialize again
        XCTAssertEqual(module.initializeCallCount, 2)
        // Trigger module initialization completion with success
        module.initializeCompletionLastValue?(nil)

        // The the initialize() completion should be executed at this point
        waitForExpectations(timeout: 5)
    }

    private func assertResultHasExpectedInfo(_ result: ModuleInitializationResult, error: NSError?, startDate: Date) {
        if let error {
            XCTAssertIdentical(result.error as? NSError, error)
        } else {
            XCTAssertNil(result.error)
        }
        XCTAssertIdentical(result.module, module)
        XCTAssertGreaterThanOrEqual(result.startDate, startDate)
        XCTAssertLessThanOrEqual(result.startDate, startDate + 2)
        XCTAssertGreaterThanOrEqual(result.endDate, Date() - 2)
        XCTAssertLessThanOrEqual(result.endDate, startDate + abs(startDate.timeIntervalSinceNow))
    }
}
