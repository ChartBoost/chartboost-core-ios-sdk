// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class DeviceInfoProviderMock: DeviceInfoProvider {
    var deviceLocale: String? = "some locale"
    var make: String = "some make"
    var model: String = "some model"
    var osName: String = "some os name"
    var osVersion: String = "some os version"
    var screenHeightPixels: Double = 989
    var screenScale: Double = 3.5
    var screenWidthPixels: Double = 660
    var volume: Double = 0.58
}
