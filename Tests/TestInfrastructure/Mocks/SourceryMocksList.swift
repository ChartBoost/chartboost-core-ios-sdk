// Copyright 2024-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

// List of protocols which we want to autogenerate mocks for using Sourcery.
//
// See the repository README.md for more info on our Sourcery integration.
//
// In order to change how mocks are generated you have to modify the `mockable.stencil` file.
// See the Sourcery docs on modifying templates: https://krzysztofzablocki.github.io/Sourcery/writing-templates.html
//
// Sourcery mockable syntax:
/*
// sourcery: mockable
// sourcery: <variable name> = "<default variable value>"
// sourcery: <function name>ReturnValue = "<default return value>"
extension <YourProtocol> {}
*/
// Note doube quotes may be omitted only if there are no whitespaces in the assigned value statement.
// In order to assign a String value use double quotes twice, or single quotes.
// E.g. ""ABCD"" and 'ABCD' will translate into "ABCD" when assigned to a default variable value.

// sourcery: mockable
// sourcery: appTrackingTransparencyStatus = .authorized
// sourcery: appSessionDuration = 34.5
// sourcery: appSessionID = ""some app session id""
// sourcery: appVersion = ""2.4.33""
// sourcery: advertisingID = ""some advertising id""
// sourcery: bundleID = ""some bundle id""
// sourcery: deviceLocale = ""some locale""
// sourcery: deviceMake = ""some make""
// sourcery: deviceModel = ""some model""
// sourcery: frameworkName = ""some framework name""
// sourcery: frameworkVersion = ""some framework version""
// sourcery: isLimitAdTrackingEnabled = false
// sourcery: isUserUnderage = false
// sourcery: networkConnectionType = .wifi
// sourcery: osName = ""some os name""
// sourcery: osVersion = ""some os version""
// sourcery: playerID = ""some player id""
// sourcery: publisherAppID = ""some pub app id""
// sourcery: publisherSessionID = ""some pub session id""
// sourcery: screenHeightPixels = 45.55
// sourcery: screenScale = 2.3
// sourcery: screenWidthPixels = 9403.44
// sourcery: vendorID = ""some vendor id""
// sourcery: vendorIDScope = .developer
// sourcery: volume = 0.87
extension AnalyticsEnvironment {}
extension AnalyticsEnvironmentMock: AdvertisingEnvironment, AttributionEnvironment {}

// sourcery: mockable
// sourcery: makeAppConfigReturnValue = ".build()"
extension AppConfigFactory {}

// sourcery: mockable
// sourcery: config = ".build()"
extension AppConfigRepository {}

// sourcery: mockable
// sourcery: makeRequestHandler = "{ _, _, completion in completion(AppConfigRequest(body: nil)) }"
extension AppConfigRequestFactory {}

// sourcery: mockable
// sourcery: appTrackingTransparencyStatus = .authorized
// sourcery: advertisingID = ""some-ifa-value""
// sourcery: isLimitAdTrackingEnabled = false
// sourcery: vendorID = ""some-idfv-value""
// sourcery: vendorIDScope = .developer
extension AppTrackingInfoProvider {}

// sourcery: mockable
// sourcery: shouldCollectConsent = false
// sourcery: moduleID = ""mock module ID""
// sourcery: moduleVersion = ""1.2.3""
extension ConsentAdapter {}
extension ConsentAdapterMock {
    convenience init(moduleID: String? = nil) {
        self.init(credentials: nil)
        if let moduleID {
            self.moduleID = moduleID
        }
    }
}

// sourcery: mockable
extension ConsentAdapterDelegate {}

// sourcery: mockable
extension ConsentAdapterProxy {}

// sourcery: mockable
// sourcery: shouldCollectConsent = false
extension ConsentManagementPlatform {}

// sourcery: mockable
extension ConsentObserver {}

// sourcery: mockable
// sourcery: deviceLocale = ""some locale""
// sourcery: make = ""some make""
// sourcery: model = ""some model""
// sourcery: osName = ""some os name""
// sourcery: osVersion = ""some os version""
// sourcery: screenHeightPixels = 989
// sourcery: screenScale = 3.5
// sourcery: screenWidthPixels = 660
// sourcery: volume = 0.58
extension DeviceInfoProvider {}

// sourcery: mockable
extension EnvironmentChangePublisher {}

// sourcery: mockable
extension EnvironmentObserver {}

// sourcery: mockable
// sourcery: systemDirectoryURLReturnValue = FileManager.default.temporaryDirectory
// sourcery: fileExistsReturnValue = true
// sourcery: readDataReturnValue = .init()
// sourcery: directoryExistsReturnValue = true
extension FileStorage {}

// sourcery: mockable
// sourcery: appVersion = ""some info plist app version""
extension InfoPlist {}

// sourcery: mockable
extension LogHandler {}

// sourcery: mockable
extension ModuleFactory {}

// sourcery: mockable
// sourcery: makeModuleInitializerReturnValue = ModuleInitializerMock()
extension ModuleInitializerFactory {}

// sourcery: mockable
// sourcery: module = "ModuleMock()"
extension ModuleInitializer {}

// sourcery: mockable
// sourcery: moduleID = ""mock module ID""
// sourcery: moduleVersion = ""1.2.3""
extension Module {}
extension ModuleMock {
    convenience init(moduleID: String? = nil) {
        self.init(credentials: nil)
        if let moduleID {
            self.moduleID = moduleID
        }
    }
}

// sourcery: mockable
extension ModuleObserver {}

// sourcery: mockable
// sourcery: connectionType = .wifi
extension NetworkConnectionTypeProvider {}

// sourcery: mockable
// sourcery: status = .reachableViaWWAN
extension NetworkStatusProvider {}

// sourcery: mockable
// sourcery: appVersion = ""some app version""
// sourcery: bundleID = ""some bundle ID""
// sourcery: frameworkName = ""some framework name""
// sourcery: frameworkVersion = ""some framework version""
// sourcery: isUserUnderage = true
// sourcery: playerID = ""some player ID""
// sourcery: publisherAppID = ""some publisher app ID""
// sourcery: publisherSessionID = ""some publisher session ID""
extension PublisherInfoProvider {}

// sourcery: mockable
extension SDKInitializer {}

// sourcery: mockable
// sourcery: session = AppSession()
extension SessionInfoProvider {}

// sourcery: mockable
extension UniversalModuleFactory {}

// sourcery: mockable
// sourcery: userAgentHandler = { completion in completion("some user agent") }
extension UserAgentProvider {}
