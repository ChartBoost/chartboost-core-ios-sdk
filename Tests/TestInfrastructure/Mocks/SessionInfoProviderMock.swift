// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class SessionInfoProviderMock: SessionInfoProvider {

    // MARK: - Call Counts and Return Values

    var resetCallCount = 0

    // MARK: - SessionInfoProvider

    var session: AppSession? = AppSession()

    func reset() {
        resetCallCount += 1
    }
}
