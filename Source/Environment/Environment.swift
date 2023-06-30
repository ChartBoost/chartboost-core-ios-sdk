// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import AppTrackingTransparency
import Foundation

final class Environment: AdvertisingEnvironment, AnalyticsEnvironment, AttributionEnvironment {

    @Injected(\.appTrackingInfoProvider) private var appTrackingInfoProvider
    @Injected(\.deviceInfoProvider) private var deviceInfoProvider
    @Injected(\.publisherInfoProvider) private var publisherInfoProvider
    @Injected(\.networkConnectionTypeProvider) private var connectionTypeProvider
    @Injected(\.sessionInfoProvider) private var sessionInfoProvider
    @Injected(\.userAgentProvider) private var userAgentProvider

    @available(iOS 14.0, *)
    var appTrackingTransparencyStatus: ATTrackingManager.AuthorizationStatus {
        appTrackingInfoProvider.appTrackingTransparencyStatus
    }

    var appSessionDuration: TimeInterval {
        sessionInfoProvider.session?.duration ?? 0
    }

    var appSessionID: String? {
        sessionInfoProvider.session?.identifier
    }

    var appVersion: String? {
        publisherInfoProvider.appVersion
    }

    var publisherAppID: String? {
        publisherInfoProvider.publisherAppID
    }

    var advertisingID: String? {
        appTrackingInfoProvider.advertisingID
    }

    var bundleID: String? {
        publisherInfoProvider.bundleID
    }

    var deviceLocale: String? {
        deviceInfoProvider.deviceLocale
    }

    var deviceMake: String {
        deviceInfoProvider.make
    }

    var deviceModel: String {
        deviceInfoProvider.model
    }

    var frameworkName: String? {
        publisherInfoProvider.frameworkName
    }

    var frameworkVersion: String? {
        publisherInfoProvider.frameworkVersion
    }

    var isLimitAdTrackingEnabled: Bool {
        appTrackingInfoProvider.isLimitAdTrackingEnabled
    }

    var isUserUnderage: Bool {
        publisherInfoProvider.isUserUnderage
    }

    var networkConnectionType: NetworkConnectionType {
        connectionTypeProvider.connectionType
    }

    var osName: String {
        deviceInfoProvider.osName
    }

    var osVersion: String {
        deviceInfoProvider.osVersion
    }

    var playerID: String? {
        publisherInfoProvider.playerID
    }

    var publisherSessionID: String? {
        publisherInfoProvider.publisherSessionID
    }

    var screenHeight: Double {
        deviceInfoProvider.screenHeight
    }

    var screenScale: Double {
        deviceInfoProvider.screenScale
    }

    var screenWidth: Double {
        deviceInfoProvider.screenWidth
    }

    var userAgent: String? {
        userAgentProvider.userAgent
    }

    var vendorID: String? {
        appTrackingInfoProvider.vendorID
    }

    var vendorIDScope: VendorIDScope {
        appTrackingInfoProvider.vendorIDScope
    }

    var volume: Double {
        deviceInfoProvider.volume
    }
}
