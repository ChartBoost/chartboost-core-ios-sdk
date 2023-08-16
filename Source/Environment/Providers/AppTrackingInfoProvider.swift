// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import AdSupport
import AppTrackingTransparency

/// Provides information related to app tracking.
protocol AppTrackingInfoProvider {

    /// The tracking authorization status, as determined by the system's AppTrackingTransparency
    /// framework.
    @available(iOS 14.0, *)
    var appTrackingTransparencyStatus: ATTrackingManager.AuthorizationStatus { get }

    /// The system advertising identifier (IFA).
    var advertisingID: String? { get }

    /// Indicates wheter the user has limited ad tracking enabled.
    var isLimitAdTrackingEnabled: Bool { get }

    /// The scope of the identifier for vendor.
    var vendorID: String? { get }

    /// The system identifier for vendor (IFV).
    var vendorIDScope: VendorIDScope { get }
}

/// Core's concrete implementation of ``AppTrackingInfoProvider``.
final class ChartboostCoreAppTrackingInfoProvider: AppTrackingInfoProvider {

    @available(iOS 14.0, *)
    var appTrackingTransparencyStatus: ATTrackingManager.AuthorizationStatus {
        ATTrackingManager.trackingAuthorizationStatus
    }

    var advertisingID: String? {
        ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }

    var isLimitAdTrackingEnabled: Bool {
        !ASIdentifierManager.shared().isAdvertisingTrackingEnabled
    }

    var vendorID: String? {
        UIDevice.current.identifierForVendor?.uuidString
    }

    var vendorIDScope: VendorIDScope {
        .developer  // IDFV is always scoped to a vendor. This is here to match Android where other scopes are possible.
    }
}
