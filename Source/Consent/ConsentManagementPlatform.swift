// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import UIKit

@objc(ChartboostCoreConsentManagementPlatform)
public protocol ConsentManagementPlatform: InitializableModule {
    var shouldCollectConsent: Bool { get }
    var consentStatus: ConsentStatus { get }
    var consents: [ConsentStandard: ConsentValue] { get }
    
    func setConsentStatus(_ status: ConsentStatus) -> Bool
    func showConsentDialog(_ type: ConsentDialogType, from viewController: UIViewController)
    func addObserver(_ observer: ConsentObserver)
    func removeObserver(_ observer: ConsentObserver)
}
