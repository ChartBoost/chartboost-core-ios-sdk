// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class ChartboostCoreModuleInitializerTests: ChartboostCoreTestCase {
    let module = ModuleMock()

    lazy var repository = ChartboostCoreModuleInitializer(
        module: module,
        queue: .main
    )

    /// Validates a `initialize()` call completes successfully if the module succeeds.
    func testInitializeIfModuleSucceeds() {
        let expectation = self.expectation(description: "wait for module initialization")
        let startDate = Date()

        repository.initialize(configuration: .init(sdkConfiguration: .init(chartboostAppID: "some app ID"))) { result in
            // Check that the result is successful
            self.assertResultHasExpectedInfo(result, error: nil, startDate: startDate)
            expectation.fulfill()
        }

        // Check that the module was asked to initialize
        XCTAssertEqual(module.initializeCallCount, 1)

        // Trigger module initialization completion with success
        module.initializeArguments.last?.completion(nil)

        // The the initialize() completion should be executed at this point
        waitForExpectations(timeout: 5)
    }

    /// Validates a `initialize()` call completes with an error if the module fails all retries.
    func testInitializeIfModuleFailsAllRetries() {
        // Set short retry values so the test runs quicker
        mocks.appConfigRepository.config = .build(
            moduleInitializationDelayMax: 1,
            moduleInitializationRetryCountMax: 3,
            moduleInitializationDelayBase: 0.1
        )

        let expectation = self.expectation(description: "wait for module initialization")
        let startDate = Date()
        let expectedError = NSError(domain: "module error", code: 8472)

        repository.initialize(configuration: .init(sdkConfiguration: .init(chartboostAppID: "some app ID"))) { result in
            // Check that the result is a failure
            self.assertResultHasExpectedInfo(result, error: expectedError, startDate: startDate)
            expectation.fulfill()
        }

        // Check that the module was asked to initialize
        XCTAssertEqual(module.initializeCallCount, 1)
        // Trigger module initialization completion with an error
        module.initializeArguments.last?.completion(NSError(domain: "", code: 3))
        // Wait a short amount of time for the retry to trigger
        wait(0.5)

        // Check that the module was asked to initialize again
        XCTAssertEqual(module.initializeCallCount, 2)
        // Trigger module initialization completion with an error
        module.initializeArguments.last?.completion(NSError(domain: "", code: 3))
        // Wait a short amount of time for the retry to trigger
        wait(0.5)

        // Check that the module was asked to initialize again
        XCTAssertEqual(module.initializeCallCount, 3)
        // Trigger module initialization completion with an error
        module.initializeArguments.last?.completion(NSError(domain: "", code: 3))
        // Wait a short amount of time for the retry to trigger
        wait(0.5)

        // Check that the module was asked to initialize again
        XCTAssertEqual(module.initializeCallCount, 4)
        // Trigger module initialization completion with an error
        module.initializeArguments.last?.completion(expectedError)

        // The the initialize() completion should be executed at this point
        waitForExpectations(timeout: 5)
    }

    /// Validates a `initialize()` call completes successfully if the module succeeds on a retry.
    func testInitializeIfModuleSucceedsOnARetry() {
        // Set short retry values so the test runs quicker
        mocks.appConfigRepository.config = .build(
            moduleInitializationDelayMax: 1,
            moduleInitializationRetryCountMax: 3,
            moduleInitializationDelayBase: 0.1
        )

        let expectation = self.expectation(description: "wait for module initialization")
        let startDate = Date()

        repository.initialize(configuration: .init(sdkConfiguration: .init(chartboostAppID: "some app ID"))) { result in
            // Check that the result is a failure
            self.assertResultHasExpectedInfo(result, error: nil, startDate: startDate)
            expectation.fulfill()
        }

        // Check that the module was asked to initialize
        XCTAssertEqual(module.initializeCallCount, 1)
        // Trigger module initialization completion with an error
        module.initializeArguments.last?.completion(NSError(domain: "", code: 3))
        // Wait a short amount of time for the retry to trigger
        wait(0.5)

        // Check that the module was asked to initialize again
        XCTAssertEqual(module.initializeCallCount, 2)
        // Trigger module initialization completion with success
        module.initializeArguments.last?.completion(nil)

        // The the initialize() completion should be executed at this point
        waitForExpectations(timeout: 5)
    }

    private func assertResultHasExpectedInfo(_ result: ModuleInitializationResult, error: NSError?, startDate: Date) {
        if let error {
            XCTAssertIdentical(result.error as? NSError, error)
        } else {
            XCTAssertNil(result.error)
        }
        XCTAssertEqual(result.moduleID, module.moduleID)
        XCTAssertEqual(result.moduleVersion, module.moduleVersion)
        XCTAssertGreaterThanOrEqual(result.startDate, startDate)
        XCTAssertLessThanOrEqual(result.startDate, startDate + 2)
        XCTAssertGreaterThanOrEqual(result.endDate, Date() - 2)
        XCTAssertLessThanOrEqual(result.endDate, startDate + abs(startDate.timeIntervalSinceNow))
    }
}
