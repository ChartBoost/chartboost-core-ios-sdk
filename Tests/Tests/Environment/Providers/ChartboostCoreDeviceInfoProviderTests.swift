// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ChartboostCoreDeviceInfoProviderTests: ChartboostCoreTestCase {

    let provider = ChartboostCoreDeviceInfoProvider()

    /// Validates that all the provider properties can be accessed without crashing or warnings.
    /// Note that the actual values depend on the device under test and cannot be known in advance.
    func testAllValues() {
        _ = provider.deviceLocale
        _ = provider.make
        _ = provider.model
        _ = provider.osName
        _ = provider.osVersion
        _ = provider.screenHeight
        _ = provider.screenScale
        _ = provider.screenWidth
        _ = provider.volume
    }
}
