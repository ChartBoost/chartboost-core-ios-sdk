// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

class ConsentObserverMock: ConsentObserver {

    // MARK: - Call Counts and Return Values

    var onConsentModuleReadyCallCount = 0
    var onConsentStatusChangeCallCount = 0
    var onConsentStatusChangeLastValue: ConsentStatus?
    var onPartnerConsentStatusChangeCallCount = 0
    var onPartnerConsentStatusChangeLastValue: (partnerID: String, status: ConsentStatus)?
    var onConsentChangeCallCount = 0
    var onConsentChangeConsentStandardLastValue: ConsentStandard?
    var onConsentChangeConsentValueLastValue: ConsentValue?

    // MARK: - ConsentObserver

    func onConsentModuleReady() {
        onConsentModuleReadyCallCount += 1
    }

    func onConsentStatusChange(_ status: ConsentStatus) {
        onConsentStatusChangeCallCount += 1
        onConsentStatusChangeLastValue = status
    }

    func onPartnerConsentStatusChange(partnerID: String, status: ConsentStatus) {
        onPartnerConsentStatusChangeCallCount += 1
        onPartnerConsentStatusChangeLastValue = (partnerID, status)
    }

    func onConsentChange(standard: ConsentStandard, value: ConsentValue?) {
        onConsentChangeCallCount += 1
        onConsentChangeConsentStandardLastValue = standard
        onConsentChangeConsentValueLastValue = value
    }
}
