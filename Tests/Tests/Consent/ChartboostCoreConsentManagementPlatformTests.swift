// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ChartboostCoreConsentManagementPlatformTests: ChartboostCoreTestCase {

    let cmp = ChartboostCoreConsentManagementPlatform()

    /// Validates that the cmp properties have default values and its methods are no-ops when the adapter is not set.
    func testDefaultValuesWhenNoAdapterIsSet() {
        XCTAssertEqual(cmp.shouldCollectConsent, false)
        XCTAssertEqual(cmp.consentStatus, .unknown)
        XCTAssertEqual(cmp.consents, [:])
        var completionCalls = 0
        cmp.grantConsent(source: .user) { result in
            XCTAssertFalse(result)
            completionCalls += 1
        }
        cmp.denyConsent(source: .user) { result in
            XCTAssertFalse(result)
            completionCalls += 1
        }
        cmp.resetConsent() { result in
            XCTAssertFalse(result)
            completionCalls += 1
        }
        cmp.showConsentDialog(.concise, from: UIViewController()) { result in
            XCTAssertFalse(result)
            completionCalls += 1
        }
        XCTAssertEqual(completionCalls, 4)
    }

    /// Validates that calls to `shouldCollectConsent` return the adapter value.
    func testShouldCollectConsent() {
        let adapter = ConsentAdapterMock()
        cmp.adapter = adapter

        adapter.shouldCollectConsent = true
        XCTAssertTrue(cmp.shouldCollectConsent)

        adapter.shouldCollectConsent = false
        XCTAssertFalse(cmp.shouldCollectConsent)
    }

    /// Validates that calls to `consentStatus` return the adapter value.
    func testConsentStatus() {
        let adapter = ConsentAdapterMock()
        cmp.adapter = adapter

        adapter.consentStatusValue = .denied
        XCTAssertEqual(cmp.consentStatus, .denied)

        adapter.consentStatusValue = .granted
        XCTAssertEqual(cmp.consentStatus, .granted)

        adapter.consentStatusValue = .unknown
        XCTAssertEqual(cmp.consentStatus, .unknown)
    }

    /// Validates that calls to `consents` return the adapter value.
    func testConsents() {
        let adapter = ConsentAdapterMock()
        cmp.adapter = adapter

        adapter.consents = [.ccpaOptIn: .denied, .gpp: "some value", .gdprConsentGiven: .granted]
        XCTAssertEqual(cmp.consents, [.ccpaOptIn: .denied, .gpp: "some value", .gdprConsentGiven: .granted])

        adapter.consents = [:]
        XCTAssertEqual(cmp.consents, [:])
    }

    /// Validates that calls to `grantConsent()` are forwarded to the adapter.
    func testGrantConsent() {
        let adapter = ConsentAdapterMock()
        cmp.adapter = adapter

        var completed = false
        cmp.grantConsent(source: .developer) { result in
            XCTAssertTrue(result)
            completed = true
        }

        XCTAssertEqual(adapter.grantConsentStatusCallCount, 1)
        XCTAssertEqual(adapter.grantConsentStatusSourceLastValue, .developer)
        adapter.grantConsentStatusLastCompletion?(true)

        XCTAssertTrue(completed)
    }

    /// Validates that calls to `denyConsent()` are forwarded to the adapter.
    func testDenyConsent() {
        let adapter = ConsentAdapterMock()
        cmp.adapter = adapter

        var completed = false
        cmp.denyConsent(source: .user) { result in
            XCTAssertFalse(result)
            completed = true
        }

        XCTAssertEqual(adapter.denyConsentStatusCallCount, 1)
        XCTAssertEqual(adapter.denyConsentStatusSourceLastValue, .user)
        adapter.denyConsentStatusLastCompletion?(false)

        XCTAssertTrue(completed)
    }

    /// Validates that calls to `resetConsent()` are forwarded to the adapter.
    func testResetConsent() {
        let adapter = ConsentAdapterMock()
        cmp.adapter = adapter

        var completed = false
        cmp.resetConsent() { result in
            XCTAssertTrue(result)
            completed = true
        }

        XCTAssertEqual(adapter.resetConsentStatusCallCount, 1)
        adapter.resetConsentStatusLastCompletion?(true)

        XCTAssertTrue(completed)
    }

    /// Validates that calls to `showConsentDialog()` are forwarded to the adapter.
    func testShowConsentDialog() {
        let adapter = ConsentAdapterMock()
        cmp.adapter = adapter
        let viewController = UIViewController()

        cmp.showConsentDialog(.detailed, from: viewController) { result in
            XCTAssertTrue(result)
        }

        XCTAssertEqual(adapter.showConsentDialogCallCount, 1)
        XCTAssertEqual(adapter.showConsentDialogTypeLastValue, .detailed)
        XCTAssertEqual(adapter.showConsentDialogViewControllerLastValue, viewController)
        adapter.showConsentDialogLastCompletion?(true)
    }

    /// Validates that multiple observers can be added and that consent updates are forwarded to them.
    func testAddObserver() {
        let observer1 = ConsentObserverMock()
        let observer2 = ConsentObserverMock()

        cmp.addObserver(observer1)

        cmp.adapter = ConsentAdapterMock()
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentModuleReadyCallCount, 1)

        cmp.onConsentStatusChange(.denied)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentStatusChangeCallCount, 1)
        XCTAssertEqual(observer1.onConsentStatusChangeLastValue, .denied)

        cmp.onConsentChange(standard: .ccpaOptIn, value: .doesNotApply)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentChangeCallCount, 1)
        XCTAssertEqual(observer1.onConsentChangeConsentStandardLastValue, .ccpaOptIn)
        XCTAssertEqual(observer1.onConsentChangeConsentValueLastValue, .doesNotApply)

        cmp.addObserver(observer2)
        cmp.onConsentStatusChange(.granted)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentStatusChangeCallCount, 2)
        XCTAssertEqual(observer1.onConsentStatusChangeLastValue, .granted)
        XCTAssertEqual(observer2.onConsentStatusChangeCallCount, 1)
        XCTAssertEqual(observer2.onConsentStatusChangeLastValue, .granted)

        cmp.onConsentChange(standard: .ccpaOptIn, value: .denied)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentChangeCallCount, 2)
        XCTAssertEqual(observer1.onConsentChangeConsentStandardLastValue, .ccpaOptIn)
        XCTAssertEqual(observer1.onConsentChangeConsentValueLastValue, .denied)
        XCTAssertEqual(observer2.onConsentChangeCallCount, 1)
        XCTAssertEqual(observer2.onConsentChangeConsentStandardLastValue, .ccpaOptIn)
        XCTAssertEqual(observer2.onConsentChangeConsentValueLastValue, .denied)
    }

    /// Validates that observers can be removed and consent updates are no longer forwarded to them.
    func testRemoveObserver() {
        let observer1 = ConsentObserverMock()
        let observer2 = ConsentObserverMock()

        cmp.addObserver(observer1)
        cmp.addObserver(observer2)

        cmp.adapter = ConsentAdapterMock()
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentModuleReadyCallCount, 1)
        XCTAssertEqual(observer2.onConsentModuleReadyCallCount, 1)

        cmp.onConsentStatusChange(.denied)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentStatusChangeCallCount, 1)
        XCTAssertEqual(observer2.onConsentStatusChangeCallCount, 1)

        cmp.removeObserver(observer1)
        cmp.onConsentStatusChange(.granted)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentStatusChangeCallCount, 1)
        XCTAssertEqual(observer2.onConsentStatusChangeCallCount, 2)

        cmp.onConsentChange(standard: .ccpaOptIn, value: .denied)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentChangeCallCount, 0)
        XCTAssertEqual(observer2.onConsentChangeCallCount, 1)

        cmp.removeObserver(observer2)
        cmp.onConsentStatusChange(.unknown)
        cmp.onConsentChange(standard: .tcf, value: "some value")
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentStatusChangeCallCount, 1)
        XCTAssertEqual(observer2.onConsentStatusChangeCallCount, 2)
        XCTAssertEqual(observer1.onConsentChangeCallCount, 0)
        XCTAssertEqual(observer2.onConsentChangeCallCount, 1)
    }

    /// Validates that adding the same observer twice does nothing the second time, so callbacks are
    /// only sent once to the same object.
    func testAddObserverIgnoresDuplicateObservers() {
        let observer = ConsentObserverMock()

        cmp.addObserver(observer)
        cmp.addObserver(observer)

        cmp.onConsentStatusChange(.denied)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer.onConsentStatusChangeCallCount, 1)
        XCTAssertEqual(observer.onConsentStatusChangeLastValue, .denied)
    }

    /// Validates that the cmp does not retain its observers.
    func testObserversAreNotRetained() {
        weak var weakObserver: ConsentObserver?

        autoreleasepool {
            let strongObserver = ConsentObserverMock()
            weakObserver = strongObserver
            cmp.addObserver(strongObserver)

            cmp.onConsentStatusChange(.denied)
            waitForTasksDispatchedOnMainQueue()

            XCTAssertEqual(strongObserver.onConsentStatusChangeCallCount, 1)
        }

        XCTAssertNil(weakObserver)

        // Just another call to make sure nothing weird happens and there's no crash
        cmp.onConsentStatusChange(.granted)
        waitForTasksDispatchedOnMainQueue()
    }

    /// Validates that the cmp adapter can be replaced.
    func testAdapterReplace() {
        let adapter1 = ConsentAdapterMock()
        let adapter2 = ConsentAdapterMock()
        cmp.adapter = adapter1

        adapter1.shouldCollectConsent = true
        XCTAssertTrue(cmp.shouldCollectConsent)
        XCTAssertIdentical(adapter1.delegate, cmp)

        adapter1.shouldCollectConsent = false
        adapter2.shouldCollectConsent = true
        cmp.adapter = adapter2
        XCTAssertTrue(cmp.shouldCollectConsent)
        XCTAssertIdentical(adapter2.delegate, cmp)
        XCTAssertNil(adapter1.delegate)

        adapter2.shouldCollectConsent = false
        XCTAssertFalse(cmp.shouldCollectConsent)
    }
}
