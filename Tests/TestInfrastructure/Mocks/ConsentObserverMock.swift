// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

class ConsentObserverMock: ConsentObserver {
    // MARK: - Call Counts and Return Values

    var onConsentModuleReadyCallCount = 0
    var onConsentModuleReadyInitialConsentsLastValue: [ConsentKey: ConsentValue]?
    var onConsentChangeCallCount = 0
    var onConsentChangeModifiedKeysLastValue: Set<ConsentKey>?
    var onConsentChangeFullConsentsLastValue: [ConsentKey: ConsentValue]?

    // MARK: - ConsentObserver

    func onConsentModuleReady(initialConsents: [ConsentKey: ConsentValue]) {
        onConsentModuleReadyCallCount += 1
        onConsentModuleReadyInitialConsentsLastValue = initialConsents
    }

    func onConsentChange(fullConsents: [ConsentKey: ConsentValue], modifiedKeys: Set<ConsentKey>) {
        onConsentChangeCallCount += 1
        onConsentChangeModifiedKeysLastValue = modifiedKeys
        onConsentChangeFullConsentsLastValue = fullConsents
    }
}
