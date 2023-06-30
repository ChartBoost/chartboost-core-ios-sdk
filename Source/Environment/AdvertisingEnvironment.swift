// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

@objc(ChartboostCoreAdvertisingEnvironment)
public protocol AdvertisingEnvironment {
    var advertisingID: String? { get }
    var bundleID: String? { get }
    var deviceLocale: String? { get }
    var deviceMake: String { get }
    var deviceModel: String { get }
    var isLimitAdTrackingEnabled: Bool { get }
    var osName: String { get }
    var osVersion: String { get }
    var screenHeight: Double { get }
    var screenScale: Double { get }
    var screenWidth: Double { get }
}
