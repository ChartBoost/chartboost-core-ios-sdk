// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import AppTrackingTransparency
import Foundation

/// Core's concrete implementation of all the environment protocols.
/// All the information is obtained from the system, the publisher, or sourced internally.
final class Environment: AdvertisingEnvironment, AnalyticsEnvironment, AttributionEnvironment, EnvironmentChangePublisher {
    @Injected(\.appTrackingInfoProvider) private var appTrackingInfoProvider
    @Injected(\.appConfig) private var appConfig
    @Injected(\.deviceInfoProvider) private var deviceInfoProvider
    @Injected(\.publisherInfoProvider) private var publisherInfoProvider
    @Injected(\.networkConnectionTypeProvider) private var connectionTypeProvider
    @Injected(\.sessionInfoProvider) private var sessionInfoProvider
    @Injected(\.userAgentProvider) private var userAgentProvider

    // List of observers added by the publisher.
    @Atomic private var observers: [WeakWrapper<EnvironmentObserver>] = []

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

    var screenHeightPixels: Double {
        deviceInfoProvider.screenHeightPixels
    }

    var screenScale: Double {
        deviceInfoProvider.screenScale
    }

    var screenWidthPixels: Double {
        deviceInfoProvider.screenWidthPixels
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

    func userAgent(completion: @escaping UserAgentCompletion) {
        userAgentProvider.userAgent(completion: completion)
    }

    // MARK: - Observers

    func addObserver(_ observer: EnvironmentObserver) {
        guard !observers.contains(where: { $0.value === observer }) else {
            logger.info("Environment observer not added: the object is already observing changes.")
            return
        }
        observers.append(WeakWrapper(observer))
    }

    func removeObserver(_ observer: EnvironmentObserver) {
        observers.removeAll(where: { $0.value === observer })
    }

    /// Iterates over all the observers in a thread-safe way, cleaning up references to any deallocated observers.
    func publishChange(to property: ObservableEnvironmentProperty) {
        $observers.mutate { observers in
            // Remove wrappers for deallocated observers
            observers.removeAll(where: { $0.value == nil })
            // Forward callback to all observers
            observers.forEach { observerWrapper in
                DispatchQueue.main.async {  // on main thread in case the observer does some UI logic here
                    if let observer = observerWrapper.value {
                        observer.onChange(property)
                    }
                }
            }
        }
    }
}
