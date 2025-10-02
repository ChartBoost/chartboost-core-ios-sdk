// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class ConsentAdapterTests: XCTestCase {
    private let adapter = SomeAdapter(credentials: [:])

    /// Validates that the default implementation for `ConsentAdapter.log(_:level:)` exists and does not crash.
    func testLog() {
        // The method just prints a string to the console, so there's not much for us to check, just making
        // sure that this does not crash.
        adapter.log("some message", level: .info)
    }

    /// Validates that the default implementation for `ConsentAdapter.userDefaultsIABStrings` exists and returns
    /// the expected values.
    func testUserDefaultsIABStrings() {
        // Clean user defaults IAB strings
        UserDefaults.standard.removeObject(forKey: "IABTCF_TCString")
        UserDefaults.standard.removeObject(forKey: "IABGPP_HDR_GppString")
        UserDefaults.standard.removeObject(forKey: "IABUSPrivacy_String")

        // Check default value
        XCTAssertEqual(adapter.userDefaultsIABStrings, [:])

        // Check one value
        UserDefaults.standard.set("12345", forKey: "IABTCF_TCString")
        XCTAssertEqual(adapter.userDefaultsIABStrings, [ConsentKeys.tcf: "12345"])

        // Check all values
        UserDefaults.standard.set("qwer", forKey: "IABTCF_TCString")
        UserDefaults.standard.set("asdf", forKey: "IABGPP_HDR_GppString")
        UserDefaults.standard.set("zxcv", forKey: "IABUSPrivacy_String")
        XCTAssertEqual(
            adapter.userDefaultsIABStrings,
            [
                ConsentKeys.tcf: "qwer",
                ConsentKeys.gpp: "asdf",
                ConsentKeys.usp: "zxcv",
            ]
        )
    }

    /// Validates that the default implementation for `ConsentAdapter.startObservingUserDefaultsIABStrings()` exists
    /// and calls the proper adapter delegate methods when the UserDefaults change.
    func testStartObservingUserDefaultsIABStrings() {
        // Clean user defaults IAB strings
        UserDefaults.standard.removeObject(forKey: "IABTCF_TCString")
        UserDefaults.standard.removeObject(forKey: "IABGPP_HDR_GppString")
        UserDefaults.standard.removeObject(forKey: "IABUSPrivacy_String")

        // Start observing UserDefaults and set the delegate
        let observer = adapter.startObservingUserDefaultsIABStrings()
        _ = observer    // just to avoid compiler warnings for not using the observer
        let delegate = ConsentAdapterDelegateMock()
        adapter.delegate = delegate

        // Set TCF - check that adapter call is made
        UserDefaults.standard.set("12345", forKey: "IABTCF_TCString")
        XCTAssertEqual(delegate.onConsentChangeCallCount, 1)
        XCTAssertEqual(delegate.onConsentChangeArguments.last, ConsentKeys.tcf)

        // Set an unrelated value - check that nothing changes
        UserDefaults.standard.set("12345", forKey: "unrelated key")
        XCTAssertEqual(delegate.onConsentChangeCallCount, 1)
        XCTAssertEqual(delegate.onConsentChangeArguments.last, ConsentKeys.tcf)

        // Set GPP - check that adapter call is made
        UserDefaults.standard.set("abcd", forKey: "IABGPP_HDR_GppString")
        XCTAssertEqual(delegate.onConsentChangeCallCount, 2)
        XCTAssertEqual(delegate.onConsentChangeArguments.last, ConsentKeys.gpp)

        // Set USP - check that adapter call is made
        UserDefaults.standard.set("09876", forKey: "IABUSPrivacy_String")
        XCTAssertEqual(delegate.onConsentChangeCallCount, 3)
        XCTAssertEqual(delegate.onConsentChangeArguments.last, ConsentKeys.usp)
    }
}

private class SomeAdapter: ConsentAdapter {
    var moduleID = "some adapter"

    var moduleVersion = "some version"

    func initialize(configuration: ModuleConfiguration, completion: @escaping (Error?) -> Void) {
    }

    var shouldCollectConsent: Bool {
        false
    }

    var consents: [ConsentKey: ConsentValue] {
        [:]
    }

    weak var delegate: ConsentAdapterDelegate?

    func showConsentDialog(_ type: ConsentDialogType, from viewController: UIViewController, completion: @escaping (Bool) -> Void) {
    }

    func grantConsent(source: ConsentSource, completion: @escaping (Bool) -> Void) {
    }

    func denyConsent(source: ConsentSource, completion: @escaping (Bool) -> Void) {
    }

    func resetConsent(completion: @escaping (Bool) -> Void) {
    }

    required init(credentials: [String: Any]?) {
    }
}
