// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class DependenciesContainerMock: DependenciesContainer {
    
    let mocks = MocksContainer()

    var analyticsEnvironment: AnalyticsEnvironment { mocks.environment }
    var appConfig: AppConfig { mocks.appConfig }
    var appConfigFactory: AppConfigFactory { mocks.appConfigFactory }
    var appConfigRepository: AppConfigRepository { mocks.appConfigRepository }
    var appConfigRequestFactory: AppConfigRequestFactory { mocks.appConfigRequestFactory }
    var appTrackingInfoProvider: AppTrackingInfoProvider { mocks.appTrackingInfoProvider }
    var consentManager: ConsentAdapterProxy & ConsentManagementPlatform { mocks.consentManager }
    var deviceInfoProvider: DeviceInfoProvider { mocks.deviceInfoProvider }
    var fileStorage: FileStorage { mocks.fileStorage }
    var infoPlist: InfoPlist { mocks.infoPlist }
    var jsonRepository: JSONRepository { mocks.jsonRepository }
    var moduleFactory: InitializableModuleFactory { mocks.moduleFactory }
    var moduleInitializerFactory: ModuleInitializerFactory { mocks.moduleInitializerFactory }
    var networkConnectionTypeProvider: NetworkConnectionTypeProvider { mocks.networkConnectionTypeProvider }
    var networkManager: NetworkManager { mocks.networkManager }
    var networkStatusProvider: NetworkStatusProvider { mocks.networkStatusProvider }
    var publisherInfoProvider: PublisherInfoProvider { mocks.publisherInfoProvider }
    var sdkInitializer: SDKInitializer { mocks.sdkInitializer }
    var sessionInfoProvider: SessionInfoProvider { mocks.sessionInfoProvider }
    var userAgentProvider: UserAgentProvider { mocks.userAgentProvider }
}
