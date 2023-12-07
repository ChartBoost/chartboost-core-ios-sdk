// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Holds references to foundational objects to be used as dependencies for other objects.
protocol DependenciesContainer: AnyObject {
    var analyticsEnvironment: AnalyticsEnvironment { get }
    var appConfig: AppConfig { get }
    var appConfigFactory: AppConfigFactory { get }
    var appConfigRepository: AppConfigRepository { get }
    var appConfigRequestFactory: AppConfigRequestFactory { get }
    var appTrackingInfoProvider: AppTrackingInfoProvider { get }
    var consentManager: ConsentManagementPlatform & ConsentAdapterProxy { get }
    var deviceInfoProvider: DeviceInfoProvider { get }
    var fileStorage: FileStorage { get }
    var infoPlist: InfoPlist { get }
    var jsonRepository: JSONRepository { get }
    var moduleFactory: InitializableModuleFactory { get }
    var moduleInitializerFactory: ModuleInitializerFactory { get }
    var networkConnectionTypeProvider: NetworkConnectionTypeProvider { get }
    var networkManager: NetworkManager { get }
    var networkStatusProvider: NetworkStatusProvider { get }
    var publisherInfoProvider: PublisherInfoProvider { get }
    var sdkInitializer: SDKInitializer { get }
    var sessionInfoProvider: SessionInfoProvider { get }
    var userAgentProvider: UserAgentProvider { get }
}

/// Dependencies container for ChartboostCore SDK objects.
final class ChartboostCoreDependenciesContainer: DependenciesContainer {
    let analyticsEnvironment: AnalyticsEnvironment = Environment(purpose: .analytics)
    var appConfig: AppConfig { appConfigRepository.config }
    let appConfigFactory: AppConfigFactory = ChartboostCoreAppConfigFactory()
    let appConfigRepository: AppConfigRepository = ChartboostCoreAppConfigRepository()
    let appConfigRequestFactory: AppConfigRequestFactory = ChartboostCoreAppConfigRequestFactory()
    let appTrackingInfoProvider: AppTrackingInfoProvider = ChartboostCoreAppTrackingInfoProvider()
    let consentManager: ConsentManagementPlatform & ConsentAdapterProxy = ChartboostCoreConsentManagementPlatform()
    let deviceInfoProvider: DeviceInfoProvider = ChartboostCoreDeviceInfoProvider()
    let fileStorage: FileStorage = ChartboostCoreFileStorage()
    let infoPlist: InfoPlist = ChartboostCoreInfoPlist()
    let jsonRepository: JSONRepository = ChartboostCoreJSONRepository(directoryLocation: .cachesDirectory, directoryName: "ChartboostCore")
    let moduleFactory: InitializableModuleFactory = ChartboostCoreInitializableModuleFactory()
    let moduleInitializerFactory: ModuleInitializerFactory = ChartboostCoreModuleInitializerFactory()
    let networkConnectionTypeProvider: NetworkConnectionTypeProvider = ChartboostCoreNetworkConnectionTypeProvider()
    let networkManager: NetworkManager = ChartboostCoreNetworkManager()
    let networkStatusProvider: NetworkStatusProvider = ChartboostCoreNetworkStatusProvider()
    let publisherInfoProvider: PublisherInfoProvider = ChartboostCorePublisherInfoProvider()
    let sdkInitializer: SDKInitializer = ChartboostCoreSDKInitializer()
    let sessionInfoProvider: SessionInfoProvider = ChartboostCoreSessionInfoProvider()
    let userAgentProvider: UserAgentProvider = ChartboostCoreUserAgentProvider()
}
