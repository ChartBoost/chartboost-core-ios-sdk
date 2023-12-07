// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Provides information related to the publisher.
protocol PublisherInfoProvider: AnyObject {

    /// The version of the app.
    var appVersion: String? { get }

    /// The app bundle identifier.
    var bundleID: String? { get }

    /// The framework name.
    var frameworkName: String? { get set }

    /// The framework version.
    var frameworkVersion: String? { get set }

    /// Indicates whether the user is underage.
    var isUserUnderage: Bool { get set }

    /// The player identifier.
    var playerID: String? { get set }

    /// The publisher-defined application identifier.
    var publisherAppID: String? { get set }

    /// The publisher-defined session identifier.
    var publisherSessionID: String? { get set }
}

/// Core's concrete implementation of ``PublisherInfoProvider``.
final class ChartboostCorePublisherInfoProvider: PublisherInfoProvider {

    @Injected(\.infoPlist) private var infoPlist

    var appVersion: String? {
        infoPlist.appVersion
    }
    
    var bundleID: String? {
        Bundle.main.bundleIdentifier
    }

    @Atomic var frameworkName: String?

    @Atomic var frameworkVersion: String?

    @Atomic var isUserUnderage = false

    @Atomic var playerID: String?

    @Atomic var publisherAppID: String?

    @Atomic var publisherSessionID: String?
}
