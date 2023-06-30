// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

@objc(ChartboostCorePublisherMetadata)
@objcMembers
public final class PublisherMetadata: NSObject {

    @Injected(\.publisherInfoProvider) private static var publisherInfoProvider

    public static func setIsUserUnderage(_ value: Bool) {
        publisherInfoProvider.isUserUnderage = value
    }

    public static func setPublisherSessionID(_ value: String) {
        publisherInfoProvider.publisherSessionID = value
    }

    public static func setPublisherAppID(_ value: String) {
        publisherInfoProvider.publisherAppID = value
    }

    public static func setFrameworkName(_ value: String) {
        publisherInfoProvider.frameworkName = value
    }

    public static func setFrameworkVersion(_ value: String) {
        publisherInfoProvider.frameworkVersion = value
    }

    public static func setPlayerID(_ value: String) {
        publisherInfoProvider.playerID = value
    }
}
