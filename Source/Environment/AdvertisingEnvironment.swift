// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import AppTrackingTransparency
import Foundation

/// An environment that contains information intended solely for advertising purposes.
/// - warning: Make sure to access UI-related properties from the main thread.
@objc(CBCAdvertisingEnvironment)
public protocol AdvertisingEnvironment {
    /// The tracking authorization status, as determined by the system's AppTrackingTransparency
    /// framework.
    @available(iOS 14.0, *)
    var appTrackingTransparencyStatus: ATTrackingManager.AuthorizationStatus { get }

    /// The system advertising identifier (IFA).
    var advertisingID: String? { get }

    /// The app bundle identifier.
    var bundleID: String? { get }

    /// The device locale string, e.g. "en-US".
    var deviceLocale: String? { get }

    /// The device make, e.g. "Apple".
    var deviceMake: String { get }

    /// The device model, e.g. "iPhone11,2".
    var deviceModel: String { get }

    /// Indicates wheter the user has limited ad tracking enabled, as determined by a
    /// call to the system framework `ASIdentifierManager.shared().isAdvertisingTrackingEnabled`.
    /// Always returns `true` on iOS 14 and above.
    /// Please note the system API is deprecated: https://developer.apple.com/documentation/adsupport/asidentifiermanager/1614148-isadvertisingtrackingenabled
    @available(iOS, deprecated: 14.0, message: "This has been replaced by `appTrackingTransparencyStatus`.")
    var isLimitAdTrackingEnabled: Bool { get }

    /// The OS name, e.g. "iOS" or "iPadOS".
    var osName: String { get }

    /// The OS version, e.g. "17.0".
    var osVersion: String { get }

    /// The height of the screen in pixels.
    var screenHeightPixels: Double { get }

    /// The screen scale.
    var screenScale: Double { get }

    /// The width of the screen in pixels.
    var screenWidthPixels: Double { get }
}
