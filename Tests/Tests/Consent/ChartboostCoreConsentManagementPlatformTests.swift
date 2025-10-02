// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class ChartboostCoreConsentManagementPlatformTests: ChartboostCoreTestCase {
    let cmp = ChartboostCoreConsentManagementPlatform()

    override func setUp() {
        super.setUp()

        // Disable consent update batching by default to make testing easier
        mocks.appConfigRepository.config = AppConfig.build(consentUpdateBatchDelay: 0)
    }

    /// Validates that the cmp properties have default values and its methods are no-ops when the adapter is not set.
    func testDefaultValuesWhenNoAdapterIsSet() {
        XCTAssertEqual(cmp.shouldCollectConsent, false)
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
        cmp.resetConsent { result in
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

    /// Validates that calls to `consents` return the adapter value.
    func testConsents() {
        let adapter = ConsentAdapterMock()
        cmp.adapter = adapter

        adapter.consents = [
            ConsentKeys.ccpaOptIn: ConsentValues.denied,
            ConsentKeys.gpp: "some value",
            ConsentKeys.gdprConsentGiven: ConsentValues.granted,
        ]
        XCTAssertEqual(
            cmp.consents,
            [
                ConsentKeys.ccpaOptIn: ConsentValues.denied,
                ConsentKeys.gpp: "some value",
                ConsentKeys.gdprConsentGiven: ConsentValues.granted,
            ]
        )

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

        XCTAssertEqual(adapter.grantConsentCallCount, 1)
        XCTAssertEqual(adapter.grantConsentArguments.last?.source, .developer)
        adapter.grantConsentArguments.last?.completion(true)

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

        XCTAssertEqual(adapter.denyConsentCallCount, 1)
        XCTAssertEqual(adapter.denyConsentArguments.last?.source, .user)
        adapter.denyConsentArguments.last?.completion(false)

        XCTAssertTrue(completed)
    }

    /// Validates that calls to `resetConsent()` are forwarded to the adapter.
    func testResetConsent() {
        let adapter = ConsentAdapterMock()
        cmp.adapter = adapter

        var completed = false
        cmp.resetConsent { result in
            XCTAssertTrue(result)
            completed = true
        }

        XCTAssertEqual(adapter.resetConsentCallCount, 1)
        adapter.resetConsentArguments.last?(true)

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
        XCTAssertEqual(adapter.showConsentDialogArguments.last?.type, .detailed)
        XCTAssertEqual(adapter.showConsentDialogArguments.last?.viewController, viewController)
        adapter.showConsentDialogArguments.last?.completion(true)
    }

    /// Validates that multiple observers can be added and that consent updates are forwarded to them.
    func testAddObserver() {
        let observer1 = ConsentObserverMock()
        let observer2 = ConsentObserverMock()
        let adapter = ConsentAdapterMock()

        cmp.addObserver(observer1)

        cmp.adapter = adapter
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentModuleReadyCallCount, 1)

        adapter.consents = [ConsentKeys.tcf: "12345"]
        cmp.onConsentChange(key: ConsentKeys.tcf)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentChangeCallCount, 1)
        XCTAssertEqual(observer1.onConsentChangeArguments.last?.modifiedKeys, [ConsentKeys.tcf] as Set<String>)
        XCTAssertEqual(observer1.onConsentChangeArguments.last?.fullConsents, adapter.consents)

        cmp.addObserver(observer2)
        adapter.consents = [ConsentKeys.tcf: "12345", "custom_key": "abcd"]
        cmp.onConsentChange(key: "custom_key")
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentChangeCallCount, 2)
        XCTAssertEqual(observer1.onConsentChangeArguments.last?.modifiedKeys, ["custom_key"] as Set<String>)
        XCTAssertEqual(observer1.onConsentChangeArguments.last?.fullConsents, adapter.consents)
        XCTAssertEqual(observer2.onConsentChangeCallCount, 1)
        XCTAssertEqual(observer2.onConsentChangeArguments.last?.modifiedKeys, ["custom_key"] as Set<String>)
        XCTAssertEqual(observer2.onConsentChangeArguments.last?.fullConsents, adapter.consents)

        adapter.consents = [ConsentKeys.tcf: "09876", "custom_key": "abcd"]
        cmp.onConsentChange(key: ConsentKeys.tcf)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentChangeCallCount, 3)
        XCTAssertEqual(observer1.onConsentChangeArguments.last?.modifiedKeys, [ConsentKeys.tcf] as Set<String>)
        XCTAssertEqual(observer1.onConsentChangeArguments.last?.fullConsents, adapter.consents)
        XCTAssertEqual(observer2.onConsentChangeCallCount, 2)
        XCTAssertEqual(observer2.onConsentChangeArguments.last?.modifiedKeys, [ConsentKeys.tcf] as Set<String>)
        XCTAssertEqual(observer2.onConsentChangeArguments.last?.fullConsents, adapter.consents)
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

        cmp.onConsentChange(key: ConsentKeys.tcf)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentChangeCallCount, 1)
        XCTAssertEqual(observer2.onConsentChangeCallCount, 1)

        cmp.removeObserver(observer1)
        cmp.onConsentChange(key: ConsentKeys.tcf)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentChangeCallCount, 1)
        XCTAssertEqual(observer2.onConsentChangeCallCount, 2)

        cmp.removeObserver(observer2)
        cmp.onConsentChange(key: ConsentKeys.gpp)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer1.onConsentChangeCallCount, 1)
        XCTAssertEqual(observer2.onConsentChangeCallCount, 2)
    }

    /// Validates that adding the same observer twice does nothing the second time, so callbacks are
    /// only sent once to the same object.
    func testAddObserverIgnoresDuplicateObservers() {
        let observer = ConsentObserverMock()

        cmp.addObserver(observer)
        cmp.addObserver(observer)

        cmp.onConsentChange(key: ConsentKeys.tcf)
        waitForTasksDispatchedOnMainQueue()

        XCTAssertEqual(observer.onConsentChangeCallCount, 1)
        XCTAssertEqual(observer.onConsentChangeArguments.last?.modifiedKeys, [ConsentKeys.tcf] as Set<String>)
    }

    /// Validates that the cmp does not retain its observers.
    func testObserversAreNotRetained() {
        weak var weakObserver: ConsentObserver?

        autoreleasepool {
            let strongObserver = ConsentObserverMock()
            weakObserver = strongObserver
            cmp.addObserver(strongObserver)

            cmp.onConsentChange(key: ConsentKeys.tcf)
            waitForTasksDispatchedOnMainQueue()

            XCTAssertEqual(strongObserver.onConsentChangeCallCount, 1)
        }

        XCTAssertNil(weakObserver)

        // Just another call to make sure nothing weird happens and there's no crash
        cmp.onConsentChange(key: ConsentKeys.tcf)
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

    /// Validates that consent adapter updates are batched when the setting is enabled.
    func testConsentChangeBatching() {
        mocks.appConfigRepository.config = AppConfig.build(consentUpdateBatchDelay: 0.2)
        ChartboostCore.logLevel = .verbose

        let observer1 = ConsentObserverMock()
        let observer2 = ConsentObserverMock()
        let adapter = ConsentAdapterMock()

        cmp.addObserver(observer1)
        cmp.addObserver(observer2)
        cmp.adapter = adapter
        waitForTasksDispatchedOnMainQueue()

        // Validate that multiple adapter calls result in a single observers call
        adapter.consents = [ConsentKeys.tcf: "12345"]
        cmp.onConsentChange(key: ConsentKeys.tcf)
        adapter.consents = [ConsentKeys.tcf: "12345", ConsentKeys.ccpaOptIn: "abcdef"]
        cmp.onConsentChange(key: ConsentKeys.ccpaOptIn)
        waitForTasksDispatchedOnMainQueue()

        wait(1) // delay is set to 0.5 but we add an extra wait to account for slow runners

        XCTAssertEqual(observer1.onConsentChangeCallCount, 1)
        XCTAssertEqual(observer1.onConsentChangeArguments.last?.modifiedKeys, [ConsentKeys.tcf, ConsentKeys.ccpaOptIn] as Set<String>)
        XCTAssertEqual(observer1.onConsentChangeArguments.last?.fullConsents, adapter.consents)
        XCTAssertEqual(observer2.onConsentChangeCallCount, 1)
        XCTAssertEqual(observer2.onConsentChangeArguments.last?.modifiedKeys, [ConsentKeys.tcf, ConsentKeys.ccpaOptIn] as Set<String>)
        XCTAssertEqual(observer2.onConsentChangeArguments.last?.fullConsents, adapter.consents)

        // Validate that a next adapter call is properly forwarded to observers

        adapter.consents = [ConsentKeys.tcf: "12345"]
        cmp.onConsentChange(key: ConsentKeys.ccpaOptIn)
        waitForTasksDispatchedOnMainQueue()

        wait(1) // delay is set to 0.5 but we add an extra wait to account for slow runners

        XCTAssertEqual(observer1.onConsentChangeCallCount, 2)
        XCTAssertEqual(observer1.onConsentChangeArguments.last?.modifiedKeys, [ConsentKeys.ccpaOptIn] as Set<String>)
        XCTAssertEqual(observer1.onConsentChangeArguments.last?.fullConsents, adapter.consents)
        XCTAssertEqual(observer2.onConsentChangeCallCount, 2)
        XCTAssertEqual(observer2.onConsentChangeArguments.last?.modifiedKeys, [ConsentKeys.ccpaOptIn] as Set<String>)
        XCTAssertEqual(observer2.onConsentChangeArguments.last?.fullConsents, adapter.consents)
    }
}
