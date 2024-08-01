// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class EnvironmentTests: ChartboostCoreTestCase {
    lazy var environment = Environment()
    /// Validates that the values for all properties are properly sourced from the corresponding info providers.
    func testAllValuesMatchInfoProviders() {
        XCTAssertEqual(environment.appTrackingTransparencyStatus, mocks.appTrackingInfoProvider.appTrackingTransparencyStatus)
        XCTAssertGreaterThanOrEqual(environment.appSessionDuration, (mocks.sessionInfoProvider.session?.duration ?? 0) - 0.5)
        XCTAssertLessThanOrEqual(environment.appSessionDuration, (mocks.sessionInfoProvider.session?.duration ?? 0) + 0.5)
        XCTAssertEqual(environment.appSessionID, mocks.sessionInfoProvider.session?.identifier)
        XCTAssertEqual(environment.appVersion, mocks.publisherInfoProvider.appVersion)
        XCTAssertEqual(environment.advertisingID, mocks.appTrackingInfoProvider.advertisingID)
        XCTAssertEqual(environment.bundleID, mocks.publisherInfoProvider.bundleID)
        XCTAssertEqual(environment.deviceLocale, mocks.deviceInfoProvider.deviceLocale)
        XCTAssertEqual(environment.deviceMake, mocks.deviceInfoProvider.make)
        XCTAssertEqual(environment.deviceModel, mocks.deviceInfoProvider.model)
        XCTAssertEqual(environment.frameworkName, mocks.publisherInfoProvider.frameworkName)
        XCTAssertEqual(environment.frameworkVersion, mocks.publisherInfoProvider.frameworkVersion)
        XCTAssertEqual(environment.isLimitAdTrackingEnabled, mocks.appTrackingInfoProvider.isLimitAdTrackingEnabled)
        XCTAssertEqual(environment.isUserUnderage, mocks.publisherInfoProvider.isUserUnderage)
        XCTAssertEqual(environment.networkConnectionType, mocks.networkConnectionTypeProvider.connectionType)
        XCTAssertEqual(environment.osName, mocks.deviceInfoProvider.osName)
        XCTAssertEqual(environment.osVersion, mocks.deviceInfoProvider.osVersion)
        XCTAssertEqual(environment.playerID, mocks.publisherInfoProvider.playerID)
        XCTAssertEqual(environment.publisherAppID, mocks.publisherInfoProvider.publisherAppID)
        XCTAssertEqual(environment.publisherSessionID, mocks.publisherInfoProvider.publisherSessionID)
        XCTAssertEqual(environment.screenHeightPixels, mocks.deviceInfoProvider.screenHeightPixels)
        XCTAssertEqual(environment.screenScale, mocks.deviceInfoProvider.screenScale)
        XCTAssertEqual(environment.screenWidthPixels, mocks.deviceInfoProvider.screenWidthPixels)
        XCTAssertEqual(environment.vendorID, mocks.appTrackingInfoProvider.vendorID)
        XCTAssertEqual(environment.vendorIDScope, mocks.appTrackingInfoProvider.vendorIDScope)
        XCTAssertEqual(environment.volume, mocks.deviceInfoProvider.volume)

        let expectation = expectation(description: "wait for fetch user agent")
        environment.userAgent { [self] userAgent in
            self.mocks.userAgentProvider.userAgent { [userAgent] anotherUserAgent in
                XCTAssertEqual(userAgent, anotherUserAgent)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10)
    }

    /// Validates that the value for `appSessionDuration` is 0 if Core has not been tried to initialize yet.
    func testAppSessionDurationIsZeroIfNoSession() {
        mocks.sessionInfoProvider.session = nil
        XCTAssertEqual(Environment().appSessionDuration, 0)
    }

    /// Validates that multiple observers can be added and that property updates are forwarded to them.
    func testAddObserver() {
        let observer1 = EnvironmentObserverMock()
        let observer2 = EnvironmentObserverMock()

        // Add first observer
        environment.addObserver(observer1)

        // Check that observer is notified
        environment.publishChange(to: .frameworkName)
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 1)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .frameworkName)

        // Add second observer
        environment.addObserver(observer2)

        // Check that both observers are notified
        environment.publishChange(to: .frameworkVersion)
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 2)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .frameworkVersion)
        XCTAssertEqual(observer2.onChangeCallCount, 1)
        XCTAssertEqual(observer2.onChangePropertyLastValue, .frameworkVersion)
    }

    /// Validates that observers can be removed and property updates are no longer forwarded to them.
    func testRemoveObserver() {
        let observer1 = EnvironmentObserverMock()
        let observer2 = EnvironmentObserverMock()

        // Add observers
        environment.addObserver(observer1)
        environment.addObserver(observer2)

        // Check that both observers get notified for property changes
        environment.publishChange(to: .playerID)
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 1)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .playerID)
        XCTAssertEqual(observer2.onChangeCallCount, 1)
        XCTAssertEqual(observer2.onChangePropertyLastValue, .playerID)

        // Remove one observer
        environment.removeObserver(observer1)

        // Check that only the other observer gets notified now
        environment.publishChange(to: .isUserUnderage)
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 1)
        XCTAssertEqual(observer1.onChangePropertyLastValue, .playerID)
        XCTAssertEqual(observer2.onChangeCallCount, 2)
        XCTAssertEqual(observer2.onChangePropertyLastValue, .isUserUnderage)

        // Remove the other observer
        environment.removeObserver(observer2)

        // Check that neither observer gets notified now
        environment.publishChange(to: .isUserUnderage)
        waitForTasksDispatchedOnMainQueue()
        XCTAssertEqual(observer1.onChangeCallCount, 1)
        XCTAssertEqual(observer2.onChangeCallCount, 2)
    }

    /// Validates that adding the same observer twice does nothing the second time, so callbacks are
    /// only sent once to the same object.
    func testAddObserverIgnoresDuplicateObservers() {
        let observer = EnvironmentObserverMock()

        environment.addObserver(observer)
        environment.addObserver(observer)

        environment.publishChange(to: .frameworkName)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer.onChangeCallCount, 1)
        XCTAssertEqual(observer.onChangePropertyLastValue, .frameworkName)
    }

    /// Validates that the publisher metadata object does not retain its observers.
    func testObserversAreNotRetained() {
        weak var weakObserver: EnvironmentObserverMock?

        autoreleasepool {
            let strongObserver = EnvironmentObserverMock()
            weakObserver = strongObserver
            environment.addObserver(strongObserver)

            environment.publishChange(to: .publisherAppID)
            waitForTasksDispatchedOnMainQueue()

            XCTAssertEqual(strongObserver.onChangeCallCount, 1)
        }

        XCTAssertNil(weakObserver)

        // Just another call to make sure nothing weird happens and there's no crash
        environment.publishChange(to: .frameworkName)
        waitForTasksDispatchedOnMainQueue()
    }
}
