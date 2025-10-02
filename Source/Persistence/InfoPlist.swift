// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// An interface to the contents of the app's Info.plist file.
protocol InfoPlist {
    /// The app version as determined by the Info.plist file.
    var appVersion: String? { get }
}

/// Core's concrete implementation of ``InfoPlist``.
final class ChartboostCoreInfoPlist: InfoPlist {
    var appVersion: String? {
        dictionary?["CFBundleShortVersionString"] as? String
    }

    // swiftlint:disable legacy_objc_type
    /// Use an `NSDictionary` API read a plist file. Such API does not have a Swift `Dictionary` counterpart.
    private lazy var dictionary: NSDictionary? = {
        guard let url = Bundle.main.url(forResource: "Info", withExtension: "plist") else {
            logger.error("Failed to find Info.plist in the main bundle.")
            return nil
        }
        do {
            return try NSDictionary(contentsOf: url, error: ())
        } catch {
            logger.error("Failed to parse Info.plist dictionary with error: \(error)")
            return nil
        }
    }()
    // swiftlint:enable legacy_objc_type
}
