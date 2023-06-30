// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import AdSupport
import AppTrackingTransparency

protocol AppTrackingInfoProvider {
    @available(iOS 14.0, *)
    var appTrackingTransparencyStatus: ATTrackingManager.AuthorizationStatus { get }
    var advertisingID: String? { get }
    var isLimitAdTrackingEnabled: Bool { get }
    var vendorID: String? { get }
    var vendorIDScope: VendorIDScope { get }
}

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
