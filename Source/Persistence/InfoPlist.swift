// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

protocol InfoPlist {
    var appVersion: String? { get }
}

final class ChartboostCoreInfoPlist: InfoPlist {

    var appVersion: String? {
        dictionary?["CFBundleShortVersionString"] as? String
    }

    private lazy var dictionary: NSDictionary? = {
        guard let url = Bundle.main.url(forResource: "Info", withExtension: "plist") else {
            assertionFailure("Failed to find Info.plist in the main bundle.")
            return nil
        }
        do {
            return try NSDictionary(contentsOf: url, error: ())
        } catch {
            // TODO: Log error
            return nil
        }
    }()
}
