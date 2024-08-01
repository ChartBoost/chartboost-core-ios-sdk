// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

class ConsentManagementPlatformMock: ConsentManagementPlatform, ConsentAdapterProxy {
    // MARK: - Call Counts and Return Values

    var grantConsentStatusCallCount = 0
    var grantConsentSourceLastValue: ConsentSource?
    var grantConsentStatusLastCompletion: ((Bool) -> Void)?
    var denyConsentStatusCallCount = 0
    var denyConsentSourceLastValue: ConsentSource?
    var denyConsentStatusLastCompletion: ((Bool) -> Void)?
    var resetConsentStatusCallCount = 0
    var resetConsentStatusLastCompletion: ((Bool) -> Void)?
    var showConsentDialogCallCount = 0
    var showConsentDialogTypeLastValue: ConsentDialogType?
    var showConsentDialogViewControllerLastValue: UIViewController?
    var showConsentDialogLastCompletion: ((Bool) -> Void)?
    var observers: [ConsentObserver] = []

    // MARK: - ConsentManagementPlatform

    var shouldCollectConsent = false

    var consents: [ConsentKey: ConsentValue] = [:]

    func grantConsent(source: ConsentSource, completion: @escaping (_ succeeded: Bool) -> Void) {
        grantConsentStatusCallCount += 1
        grantConsentSourceLastValue = source
        grantConsentStatusLastCompletion = completion
    }

    func denyConsent(source: ConsentSource, completion: @escaping (_ succeeded: Bool) -> Void) {
        denyConsentStatusCallCount += 1
        denyConsentSourceLastValue = source
        denyConsentStatusLastCompletion = completion
    }

    func resetConsent(completion: @escaping (_ succeeded: Bool) -> Void) {
        resetConsentStatusCallCount += 1
        resetConsentStatusLastCompletion = completion
    }

    func showConsentDialog(
        _ type: ConsentDialogType,
        from viewController: UIViewController,
        completion: @escaping (_ succeeded: Bool) -> Void
    ) {
        showConsentDialogCallCount += 1
        showConsentDialogTypeLastValue = type
        showConsentDialogViewControllerLastValue = viewController
        showConsentDialogLastCompletion = completion
    }

    func addObserver(_ observer: ConsentObserver) {
        observers.append(observer)
    }

    func removeObserver(_ observer: ConsentObserver) {
        observers.removeAll(where: { $0 === observer })
    }

    // MARK: - ConsentAdapterProxy

    var adapter: ConsentAdapter? = ConsentAdapterMock()
}
