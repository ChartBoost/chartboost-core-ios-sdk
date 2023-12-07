// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

class ConsentAdapterMock: InitializableModuleMock, ConsentAdapter {

    // MARK: - Call Counts and Return Values

    var grantConsentStatusCallCount = 0
    var grantConsentStatusSourceLastValue: ConsentStatusSource?
    var grantConsentStatusLastCompletion: ((Bool) -> Void)?
    var denyConsentStatusCallCount = 0
    var denyConsentStatusSourceLastValue: ConsentStatusSource?
    var denyConsentStatusLastCompletion: ((Bool) -> Void)?
    var resetConsentStatusCallCount = 0
    var resetConsentStatusLastCompletion: ((Bool) -> Void)?
    var showConsentDialogCallCount = 0
    var showConsentDialogTypeLastValue: ConsentDialogType?
    var showConsentDialogViewControllerLastValue: UIViewController?
    var showConsentDialogLastCompletion: ((Bool) -> Void)?
    var consentStatusValue: ConsentStatus = .granted
    var partnerConsentStatusValue: [String : ConsentStatus] = [:]

    // MARK: - ConsentAdapter

    var delegate: ConsentAdapterDelegate?

    var shouldCollectConsent = false

    var consentStatus: ConsentStatus {
        consentStatusValue
    }

    var partnerConsentStatus: [String : ConsentStatus] {
        partnerConsentStatusValue
    }

    var consents: [ConsentStandard: ConsentValue] = [:]

    func grantConsent(source: ConsentStatusSource, completion: @escaping (_ succeeded: Bool) -> Void) {
        grantConsentStatusCallCount += 1
        grantConsentStatusSourceLastValue = source
        grantConsentStatusLastCompletion = completion
    }

    func denyConsent(source: ConsentStatusSource, completion: @escaping (_ succeeded: Bool) -> Void) {
        denyConsentStatusCallCount += 1
        denyConsentStatusSourceLastValue = source
        denyConsentStatusLastCompletion = completion
    }

    func resetConsent(completion: @escaping (_ succeeded: Bool) -> Void) {
        resetConsentStatusCallCount += 1
        resetConsentStatusLastCompletion = completion
    }

    func showConsentDialog(_ type: ConsentDialogType, from viewController: UIViewController, completion: @escaping (_ succeeded: Bool) -> Void) {
        showConsentDialogCallCount += 1
        showConsentDialogTypeLastValue = type
        showConsentDialogViewControllerLastValue = viewController
        showConsentDialogLastCompletion = completion
    }
}
