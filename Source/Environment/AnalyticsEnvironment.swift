// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import AppTrackingTransparency
import Foundation

/// An environment that contains information intended solely for analytics purposes.
/// - warning: Make sure to access UI-related properties from the main thread.
@objc(CBCAnalyticsEnvironment)
public protocol AnalyticsEnvironment {

    /// The tracking authorization status, as determined by the system's AppTrackingTransparency
    /// framework.
    @available(iOS 14.0, *)
    var appTrackingTransparencyStatus: ATTrackingManager.AuthorizationStatus { get }

    /// The session duration, or `0` if the ``ChartboostCore/initializeSDK(with:moduleObserver:)`` method has not been called yet.
    /// A session starts the moment ``ChartboostCore/initializeSDK(with:moduleObserver:)`` is called for the first time, or when
    /// the user consent status changes from ``ConsentStatus/granted`` to any other status.
    var appSessionDuration: TimeInterval { get }

    /// The session identifier, or `nil` if the ``ChartboostCore/initializeSDK(with:moduleObserver:)`` method has not been called yet.
    /// A session starts the moment ``ChartboostCore/initializeSDK(with:moduleObserver:)`` is called for the first time, or when
    /// the user consent status changes from ``ConsentStatus/granted`` to any other status.
    var appSessionID: String? { get }

    /// The version of the app.
    var appVersion: String? { get }

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

    /// The framework name set by the publisher through a call to ``PublisherMetadata/setFrameworkName(_:)``.
    var frameworkName: String? { get }

    /// The framework version set by the publisher through a call to ``PublisherMetadata/setFrameworkVersion(_:)``.
    var frameworkVersion: String? { get }

    /// Indicates wheter the user has limited ad tracking enabled, as determined by a
    /// call to the system framework `ASIdentifierManager.shared().isAdvertisingTrackingEnabled`.
    /// Please note the system API is deprecated: https://developer.apple.com/documentation/adsupport/asidentifiermanager/1614148-isadvertisingtrackingenabled
    var isLimitAdTrackingEnabled: Bool { get }

    /// Indicates whether the user is underage. This is determined by the latest value set by the publisher through
    /// a call to ``PublisherMetadata/setIsUserUnderage(_:)``, as well as by the "child-directed" option defined on
    /// the Chartboost Core dashboard. The more restrictive option is used.
    var isUserUnderage: Bool { get }

    /// The current network connection type, e.g. `wifi`.
    var networkConnectionType: NetworkConnectionType { get }

    /// The OS name, e.g. "iOS" or "iPadOS".
    var osName: String { get }

    /// The OS version, e.g. "17.0".
    var osVersion: String { get }

    /// The player identifier set by the publisher through a call to ``PublisherMetadata/setPlayerID(_:)``.
    var playerID: String? { get }

    /// The publisher-defined application identifier set by the publisher through a call to ``PublisherMetadata/setPublisherAppID(_:)``.
    var publisherAppID: String? { get }

    /// The publisher-defined session identifier set by the publisher through a call to ``PublisherMetadata/setPublisherSessionID(_:)``.
    var publisherSessionID: String? { get }

    /// The height of the screen in pixels.
    var screenHeight: Double { get }

    /// The screen scale.
    var screenScale: Double { get }

    /// The width of the screen in pixels.
    var screenWidth: Double { get }

    /// The system identifier for vendor (IFV).
    var vendorID: String? { get }

    /// The scope of the identifier for vendor.
    /// Currently the only value possible is ``VendorIDScope/developer``.
    var vendorIDScope: VendorIDScope { get }

    /// The device volume level.
    var volume: Double { get }

    /// Obtain the device user agent asynchronously.
    func userAgent(completion: @escaping (_ userAgent: String) -> Void)
}
