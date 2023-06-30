// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

protocol PublisherInfoProvider: AnyObject {
    var appVersion: String? { get }
    var bundleID: String? { get }
    var frameworkName: String? { get set }
    var frameworkVersion: String? { get set }
    var isUserUnderage: Bool { get set }
    var playerID: String? { get set }
    var publisherAppID: String? { get set }
    var publisherSessionID: String? { get set }
}

final class ChartboostCorePublisherInfoProvider: PublisherInfoProvider {

    @Injected(\.infoPlist) private var infoPlist

    var appVersion: String? {
        infoPlist.appVersion
    }
    
    var bundleID: String? {
        Bundle.main.bundleIdentifier
    }

    var frameworkName: String?
    var frameworkVersion: String?
    var isUserUnderage = false
    var playerID: String?
    var publisherAppID: String?
    var publisherSessionID: String?
}
