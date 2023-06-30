// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import AppTrackingTransparency
import Foundation

@objc(ChartboostCoreAnalyticsEnvironment)
public protocol AnalyticsEnvironment {
    @available(iOS 14.0, *)
    var appTrackingTransparencyStatus: ATTrackingManager.AuthorizationStatus { get }
    var appSessionDuration: TimeInterval { get }
    var appSessionID: String? { get }
    var appVersion: String? { get }
    var advertisingID: String? { get }
    var bundleID: String? { get }
    var deviceLocale: String? { get }
    var deviceMake: String { get }
    var deviceModel: String { get }
    var frameworkName: String? { get }
    var frameworkVersion: String? { get }
    var isLimitAdTrackingEnabled: Bool { get }
    var isUserUnderage: Bool { get }
    var networkConnectionType: NetworkConnectionType { get }
    var osName: String { get }
    var osVersion: String { get }
    var playerID: String? { get }
    var publisherAppID: String? { get }
    var publisherSessionID: String? { get }
    var screenHeight: Double { get }
    var screenScale: Double { get }
    var screenWidth: Double { get }
    var userAgent: String? { get }
    var vendorID: String? { get }
    var vendorIDScope: VendorIDScope { get }
    var volume: Double { get }
}
