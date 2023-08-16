// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

/// A wrapper over all the possible mocks.
/// Any new mock used by a test should be added here and accessed through the `ChartboostCoreTestCase.mocks` property.
/// This will ensure that the mock value is used for dependency injection on ChartboostCore SDK classes.
final class MocksContainer {
    var appConfig: AppConfig { appConfigRepository.config }
    var appConfigFactory = AppConfigFactoryMock()
    var appConfigRequestFactory = AppConfigRequestFactoryMock()
    var appConfigRepository = AppConfigRepositoryMock()
    var appTrackingInfoProvider = AppTrackingInfoProviderMock()
    var consentManager = ConsentManagementPlatformMock()
    var deviceInfoProvider = DeviceInfoProviderMock()
    var environment = EnvironmentMock()
    var fileStorage = FileStorageMock()
    var infoPlist = InfoPlistMock()
    var jsonRepository = JSONRepositoryMock()
    var moduleFactory = InitializableModuleFactoryMock()
    var moduleInitializerFactory = ModuleInitializerFactoryMock()
    var networkConnectionTypeProvider = NetworkConnectionTypeProviderMock()
    var networkManager = NetworkManagerMock()
    var networkStatusProvider = NetworkStatusProviderMock()
    var publisherInfoProvider = PublisherInfoProviderMock()
    var sdkInitializer = SDKInitializerMock()
    var sessionInfoProvider = SessionInfoProviderMock()
    var userAgentProvider = UserAgentProviderMock()
}

