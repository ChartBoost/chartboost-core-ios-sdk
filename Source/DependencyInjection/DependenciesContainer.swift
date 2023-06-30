// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Holds references to foundational objects to be used as dependencies for other objects.
protocol DependenciesContainer {
    var appTrackingInfoProvider: AppTrackingInfoProvider { get }
    var deviceInfoProvider: DeviceInfoProvider { get }
    var environment: Environment { get }
    var infoPlist: InfoPlist { get }
    var publisherInfoProvider: PublisherInfoProvider { get }
    var networkConnectionTypeProvider: NetworkConnectionTypeProvider { get }
    var networkStatusProvider: NetworkStatusProvider { get }
    var sdkInitializer: SDKInitializer { get }
    var sessionInfoProvider: SessionInfoProvider { get }
    var userAgentProvider: UserAgentProvider { get }
}

/// Dependencies container for ChartboostCore SDK objects.
final class ChartboostCoreDependenciesContainer: DependenciesContainer {
    let appTrackingInfoProvider: AppTrackingInfoProvider = ChartboostCoreAppTrackingInfoProvider()
    let deviceInfoProvider: DeviceInfoProvider = ChartboostCoreDeviceInfoProvider()
    let environment = Environment()
    let infoPlist: InfoPlist = ChartboostCoreInfoPlist()
    let publisherInfoProvider: PublisherInfoProvider = ChartboostCorePublisherInfoProvider()
    let networkConnectionTypeProvider: NetworkConnectionTypeProvider = ChartboostCoreNetworkConnectionTypeProvider()
    let networkStatusProvider: NetworkStatusProvider = ChartboostCoreNetworkStatusProvider()
    let sdkInitializer: SDKInitializer = ChartboostCoreSDKInitializer()
    let sessionInfoProvider: SessionInfoProvider = ChartboostCoreSessionInfoProvider()
    let userAgentProvider: UserAgentProvider = ChartboostCoreUserAgentProvider()
}
