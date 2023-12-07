// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class PublisherInfoProviderMock: PublisherInfoProvider {

    var appVersion: String? = "some app version"
    var bundleID: String? = "some bundle ID"
    var frameworkName: String? = "some framework name"
    var frameworkVersion: String? = "some framework version"
    var isUserUnderage: Bool = true
    var playerID: String? = "some player ID"
    var publisherAppID: String? = "some publisher app ID"
    var publisherSessionID: String? = "some publisher session ID"
}
