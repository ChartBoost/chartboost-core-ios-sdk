// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class ChartboostCoreInfoPlistTests: ChartboostCoreTestCase {
    let infoPlist = ChartboostCoreInfoPlist()

    /// Validates that the InfoPlist returns an app version from the InfoPlist file without crashing.
    /// Unfortunately the Info.plist file does not exist when running our unit tests so we cannot
    /// validate its value.
    func testAppVersion() {
        _ = infoPlist.appVersion
    }
}
