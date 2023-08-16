// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import AppTrackingTransparency
@testable import ChartboostCoreSDK

final class AppTrackingInfoProviderMock: AppTrackingInfoProvider {

    var appTrackingTransparencyStatus: ATTrackingManager.AuthorizationStatus = .authorized
    var advertisingID: String? = "some-ifa-value"
    var isLimitAdTrackingEnabled = false
    var vendorID: String? = "some-idfv-value"
    var vendorIDScope: VendorIDScope = .developer
}
