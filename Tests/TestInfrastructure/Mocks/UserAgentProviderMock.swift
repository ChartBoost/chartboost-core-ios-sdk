// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class UserAgentProviderMock: UserAgentProvider {

    // MARK: - Call Counts and Return Values

    var userAgentFetchCount = 0
    var privateCachedUserAgent: String? = nil

    // MARK: - UserAgentProvider

    func userAgent(completion: @escaping UserAgentCompletion) {
        if privateCachedUserAgent == nil {
            userAgentFetchCount += 1
        }
        privateCachedUserAgent = "some user agent"
        completion("some user agent")
    }
}
