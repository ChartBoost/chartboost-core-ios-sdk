// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class PublisherMetadataTests: ChartboostCoreTestCase {

    let publisherMetadata = PublisherMetadata()

    /// Validates that all the setter methods just forward the information to the `publisherInfoProvider`.
    func testSetters() {
        publisherMetadata.setFrameworkName("some framework name 1234")
        publisherMetadata.setFrameworkVersion("some framework version 1234")
        publisherMetadata.setIsUserUnderage(false)
        publisherMetadata.setPlayerID("some player ID 1234")
        publisherMetadata.setPublisherAppID("some publisher app ID 1234")
        publisherMetadata.setPublisherSessionID("some publisher session ID 1234")

        XCTAssertEqual(mocks.publisherInfoProvider.frameworkName, "some framework name 1234")
        XCTAssertEqual(mocks.publisherInfoProvider.frameworkVersion, "some framework version 1234")
        XCTAssertEqual(mocks.publisherInfoProvider.isUserUnderage, false)
        XCTAssertEqual(mocks.publisherInfoProvider.playerID, "some player ID 1234")
        XCTAssertEqual(mocks.publisherInfoProvider.publisherAppID, "some publisher app ID 1234")
        XCTAssertEqual(mocks.publisherInfoProvider.publisherSessionID, "some publisher session ID 1234")
    }

    /// Validates that multiple observers can be added and that property updates are forwarded to them.
    func testAddObserver() {
        let observer1 = PublisherMetadataObserverMock()
        let observer2 = PublisherMetadataObserverMock()

        // Add first observer
        publisherMetadata.addObserver(observer1)

        // Check that observer is notified for all property changes
        publisherMetadata.setFrameworkName("some framework name 1234")
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 1)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .frameworkName)

        publisherMetadata.setFrameworkVersion("some framework version 1234")
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 2)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .frameworkVersion)

        publisherMetadata.setIsUserUnderage(false)
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 3)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .isUserUnderage)

        publisherMetadata.setPlayerID("some player ID 1234")
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 4)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .playerID)

        publisherMetadata.setPublisherAppID("some publisher app ID 1234")
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 5)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .publisherAppID)

        publisherMetadata.setPublisherSessionID("some publisher session ID 1234")
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 6)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .publisherSessionID)

        // Add second observer
        publisherMetadata.addObserver(observer2)

        // Check that both observers are notified for all property changes
        publisherMetadata.setFrameworkName(nil)
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 7)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .frameworkName)
        XCTAssertEqual(observer2.onChangeCallCount, 1)
        XCTAssertEqual(observer2.onChangePropertyLastValue, .frameworkName)

        publisherMetadata.setFrameworkVersion(nil)
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 8)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .frameworkVersion)
        XCTAssertEqual(observer2.onChangeCallCount, 2)
        XCTAssertEqual(observer2.onChangePropertyLastValue, .frameworkVersion)

        publisherMetadata.setIsUserUnderage(true)
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 9)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .isUserUnderage)
        XCTAssertEqual(observer2.onChangeCallCount, 3)
        XCTAssertEqual(observer2.onChangePropertyLastValue, .isUserUnderage)

        publisherMetadata.setPlayerID(nil)
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 10)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .playerID)
        XCTAssertEqual(observer2.onChangeCallCount, 4)
        XCTAssertEqual(observer2.onChangePropertyLastValue, .playerID)

        publisherMetadata.setPublisherAppID(nil)
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 11)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .publisherAppID)
        XCTAssertEqual(observer2.onChangeCallCount, 5)
        XCTAssertEqual(observer2.onChangePropertyLastValue, .publisherAppID)

        publisherMetadata.setPublisherSessionID(nil)
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 12)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .publisherSessionID)
        XCTAssertEqual(observer2.onChangeCallCount, 6)
        XCTAssertEqual(observer2.onChangePropertyLastValue, .publisherSessionID)
    }

    /// Validates that observers can be removed and property updates are no longer forwarded to them.
    func testRemoveObserver() {
        let observer1 = PublisherMetadataObserverMock()
        let observer2 = PublisherMetadataObserverMock()

        // Add observers
        publisherMetadata.addObserver(observer1)
        publisherMetadata.addObserver(observer2)

        // Check that botht observer get notified for property changes
        publisherMetadata.setFrameworkName(nil)
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 1)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .frameworkName)
        XCTAssertEqual(observer2.onChangeCallCount, 1)
        XCTAssertEqual(observer2.onChangePropertyLastValue, .frameworkName)

        // Remove one observer
        publisherMetadata.removeObserver(observer1)

        // Check that only the other observer gets notified now
        publisherMetadata.setPlayerID("some player ID value")
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 1)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .frameworkName)
        XCTAssertEqual(observer2.onChangeCallCount, 2)
        XCTAssertEqual(observer2.onChangePropertyLastValue, .playerID)

        // Remove the other observer
        publisherMetadata.removeObserver(observer2)

        // Check that neither observer gets notified now
        publisherMetadata.setIsUserUnderage(true)
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 1)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .frameworkName)
        XCTAssertEqual(observer2.onChangeCallCount, 2)
        XCTAssertEqual(observer2.onChangePropertyLastValue, .playerID)
    }

    /// Validates that adding the same observer twice does nothing the second time, so callbacks are
    /// only sent once to the same object.
    func testAddObserverIgnoresDuplicateObservers() {
        let observer = PublisherMetadataObserverMock()

        publisherMetadata.addObserver(observer)
        publisherMetadata.addObserver(observer)

        publisherMetadata.setFrameworkName(nil)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer.onChangeCallCount, 1)
        XCTAssertEqual(observer.onChangePropertyLastValue, .frameworkName)
    }

    /// Validates that the publisher metadata object does not retain its observers.
    func testObserversAreNotRetained() {
        weak var weakObserver: PublisherMetadataObserver?

        autoreleasepool {
            let strongObserver = PublisherMetadataObserverMock()
            weakObserver = strongObserver
            publisherMetadata.addObserver(strongObserver)

            publisherMetadata.setFrameworkName(nil)
            waitForTasksDispatchedOnMainQueue()

            XCTAssertEqual(strongObserver.onChangeCallCount, 1)
        }

        XCTAssertNil(weakObserver)

        // Just another call to make sure nothing weird happens and there's no crash
        publisherMetadata.setFrameworkName(nil)
        waitForTasksDispatchedOnMainQueue()
    }
}
