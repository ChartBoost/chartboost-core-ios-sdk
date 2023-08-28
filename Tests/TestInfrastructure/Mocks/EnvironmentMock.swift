// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import AppTrackingTransparency

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

    var isLimitAdTrackingEnabled: Bool = false

    var isUserUnderage: Bool = false

    var networkConnectionType: ChartboostCoreSDK.NetworkConnectionType = .wifi

    var osName: String = "some os name"

    var osVersion: String = "some os version"

    var playerID: String? = "some player id"

    var publisherAppID: String? = "some pub app id"

    var publisherSessionID: String? = "some pub session id"

    var screenHeight: Double = 45.55

    var screenScale: Double = 2.3

    var screenWidth: Double = 9403.44

    var vendorID: String? = "some vendor id"

    var vendorIDScope: ChartboostCoreSDK.VendorIDScope = .developer

    var volume: Double = 0.87

    func userAgent(completion: @escaping (String) -> Void) {
        completion("some user agent")
    }
}
