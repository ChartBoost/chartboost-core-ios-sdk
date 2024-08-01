// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import AppTrackingTransparency
@testable import ChartboostCoreSDK

final class EnvironmentMock: AdvertisingEnvironment, AnalyticsEnvironment, AttributionEnvironment {
    var appTrackingTransparencyStatus: ATTrackingManager.AuthorizationStatus = .authorized

    var appSessionDuration: TimeInterval = 34.5

    var appSessionID: String? = "some app session id"

    var appVersion: String? = "2.4.33"

    var advertisingID: String? = "some advertising id"

    var bundleID: String? = "some bundle id"

    var deviceLocale: String? = "some locale"

    var deviceMake: String = "some make"

    var deviceModel: String = "some model"

    var frameworkName: String? = "some framework name"

    var frameworkVersion: String? = "some framework version"

    var isLimitAdTrackingEnabled = false

    var isUserUnderage = false

    var networkConnectionType: ChartboostCoreSDK.NetworkConnectionType = .wifi

    var osName: String = "some os name"

    var osVersion: String = "some os version"

    var playerID: String? = "some player id"

    var publisherAppID: String? = "some pub app id"

    var publisherSessionID: String? = "some pub session id"

    var screenHeightPixels: Double = 45.55

    var screenScale: Double = 2.3

    var screenWidthPixels: Double = 9403.44

    var vendorID: String? = "some vendor id"

    var vendorIDScope: ChartboostCoreSDK.VendorIDScope = .developer

    var volume: Double = 0.87

    func userAgent(completion: @escaping (String?) -> Void) {
        completion("some user agent")
    }

    func addObserver(_ observer: EnvironmentObserver) {
    }

    func removeObserver(_ observer: EnvironmentObserver) {
    }
}
