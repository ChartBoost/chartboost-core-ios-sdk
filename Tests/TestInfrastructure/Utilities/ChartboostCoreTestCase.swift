// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

/// A XCTestCase subclass that replaces the shared dependencies container by a mock.
class ChartboostCoreTestCase: XCTestCase {
    private let dependenciesContainer = DependenciesContainerMock()

    /// Mocks used for dependency injection in all test classes.
    /// Properties that use the Injected property wrapper get these values injected.
    var mocks: MocksContainer { dependenciesContainer.mocks }

    override func setUp() {
        // Replace the shared dependencies container, so when a ChartboostCore SDK class is created in order to 
        // test it all its @Injected properties are assigned to mock values.
        DependenciesContainerStore.container = dependenciesContainer
    }

    func waitForTasksDispatchedOnMainQueue() {
        let expectation = self.expectation(description: "wait for task dispatched asynchronously on main thread")
        DispatchQueue.main.async {
            // Since the main queue is a fi-fo queue, by the time this closure is executed all previously
            // dispatched closures would have been executed too.
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

    // Small wait to give some component time to do an operation on its internal queue
    func waitForTasksDispatchedOnBackgroundQueue() {
        wait(0.5)
    }

    func wait(_ seconds: TimeInterval) {
        let expectation = self.expectation(description: "wait for \(seconds) seconds")
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
