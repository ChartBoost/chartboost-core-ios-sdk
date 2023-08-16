// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import AppTrackingTransparency
import Foundation

/// Core's concrete implementation of all the environment protocols.
/// All the information is obtained from the system, the publisher, or sourced internally.
/// - note: The ``advertisingID`` is gated for advertising and attribution purposes when the user is underage.
final class Environment: AdvertisingEnvironment, AnalyticsEnvironment, AttributionEnvironment {

    enum Purpose {
        case advertising
        case analytics
        case attribution
    }

    @Injected(\.appTrackingInfoProvider) private var appTrackingInfoProvider
    @Injected(\.appConfig) private var appConfig
    @Injected(\.deviceInfoProvider) private var deviceInfoProvider
    @Injected(\.publisherInfoProvider) private var publisherInfoProvider
    @Injected(\.networkConnectionTypeProvider) private var connectionTypeProvider
    @Injected(\.sessionInfoProvider) private var sessionInfoProvider
    @Injected(\.userAgentProvider) private var userAgentProvider

    let purpose: Purpose

    init(purpose: Purpose) {
        self.purpose = purpose
    }

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
        // Gate IFA if user is underage for advertising and attribution purposes.
        if (publisherInfoProvider.isUserUnderage || appConfig.isChildDirected == true)
            && (purpose == .advertising || purpose == .attribution) {
            return nil
        }
        return appTrackingInfoProvider.advertisingID
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
