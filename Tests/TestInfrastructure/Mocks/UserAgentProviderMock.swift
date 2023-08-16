// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class UserAgentProviderMock: UserAgentProvider {

    // MARK: - Call Counts and Return Values

    var updateUserAgentCallCount = 0

    // MARK: - SessionInfoProvider

    var userAgent: String? = "some user agent"

    func updateUserAgent() {
        updateUserAgentCallCount += 1
    }
}
