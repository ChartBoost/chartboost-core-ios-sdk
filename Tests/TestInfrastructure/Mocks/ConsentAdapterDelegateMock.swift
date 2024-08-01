// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

class ConsentAdapterDelegateMock: ConsentAdapterDelegate {
    // MARK: - Call Counts and Return Values

    var onConsentChangeCallCount = 0
    var onConsentChangeConsentKeyLastValue: ConsentKey?

    // MARK: - ConsentAdapterDelegate

    func onConsentChange(key: ConsentKey) {
        onConsentChangeCallCount += 1
        onConsentChangeConsentKeyLastValue = key
    }
}
