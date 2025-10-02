// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@import AppTrackingTransparency;
@import ChartboostCoreSDK;
@import XCTest;

// MARK: - CBCConsentAdapter

@interface CBCConsentAdapterMock : XCTestCase <CBCConsentAdapter>
@property (nonatomic, readonly, copy) NSString *moduleID;
@property (nonatomic, readonly, copy) NSString *moduleVersion;
@property (nonatomic, readonly) BOOL shouldCollectConsent;
@property (nonatomic, readonly, copy) NSDictionary<NSString *,NSString *> *consents;
@property (nonatomic, nullable) id<CBCConsentAdapterDelegate> delegate;
@end

@implementation CBCConsentAdapterMock
- (nonnull instancetype)initWithCredentials:(NSDictionary<NSString *,id> * _Nullable)credentials { return [super init]; }
- (void)initializeWithConfiguration:(CBCModuleConfiguration * _Nonnull)configuration
                         completion:(void (^ _Nonnull)(NSError * _Nullable))completion {}
- (void)showConsentDialog:(enum CBCConsentDialogType)type from:(UIViewController *)viewController completion:(void (^)(BOOL))completion {}
- (void)grantConsentWithSource:(enum CBCConsentSource)source completion:(void (^)(BOOL))completion {}
- (void)denyConsentWithSource:(enum CBCConsentSource)source completion:(void (^)(BOOL))completion {}
- (void)resetConsentWithCompletion:(void (^)(BOOL))completion {}
@end

// MARK: - CBCConsentAdapterDelegate

@interface CBCConsentAdapterDelegateMock : XCTestCase <CBCConsentAdapterDelegate>
@end

@implementation CBCConsentAdapterDelegateMock
- (void)onConsentChangeWithKey:(NSString *)key {}
@end

// MARK: - CBCConsentManagementPlatform

@interface CBCConsentManagementPlatformMock : XCTestCase <CBCConsentManagementPlatform>
@property (nonatomic, readonly) BOOL shouldCollectConsent;
@property (nonatomic, readonly, copy) NSDictionary<NSString *,NSString *> *consents;
@end

@implementation CBCConsentManagementPlatformMock
- (void)grantConsentWithSource:(enum CBCConsentSource)source completion:(void (^)(BOOL))completion {}
- (void)denyConsentWithSource:(enum CBCConsentSource)source completion:(void (^)(BOOL))completion {}
- (void)resetConsentWithCompletion:(void (^)(BOOL))completion {}
- (void)showConsentDialog:(enum CBCConsentDialogType)type from:(UIViewController *)viewController completion:(void (^)(BOOL))completion {}
- (void)addObserver:(id<CBCConsentObserver>)observer {}
- (void)removeObserver:(id<CBCConsentObserver>)observer {}
@end

// MARK: - CBCConsentObserver

@interface CBCConsentObserverMock : XCTestCase <CBCConsentObserver>
@end

@implementation CBCConsentObserverMock
- (void)onConsentModuleReadyWithInitialConsents:(NSDictionary<NSString *,NSString *> *)initialConsents {}
- (void)onConsentChangeWithFullConsents:(NSDictionary<NSString *,NSString *> *)fullConsents
                           modifiedKeys:(NSSet<NSString *> *)modifiedKeys {}
@end

// MARK: - CBCEnvironmentObserver

@interface CBCEnvironmentObserverMock : XCTestCase <CBCEnvironmentObserver>
@end

@implementation CBCEnvironmentObserverMock
- (void)onChange:(enum CBCObservableEnvironmentProperty)property {}
@end

// MARK: - CBCLogHandler

@interface CBCLogHandlerMock : XCTestCase <CBCLogHandler>
@end

@implementation CBCLogHandlerMock
- (void)handle:(CBCLogEntry *)entry {}
@end

// MARK: - CBCModule

@interface CBCModuleMock : XCTestCase <CBCModule>
@property (nonatomic, readonly, copy) NSString *moduleID;
@property (nonatomic, readonly, copy) NSString *moduleVersion;
@end

@implementation CBCModuleMock
- (instancetype)initWithCredentials:(NSDictionary<NSString *,id> *)credentials { return [super init]; }
- (void)initializeWithConfiguration:(CBCModuleConfiguration * _Nonnull)configuration
                         completion:(void (^ _Nonnull)(NSError * _Nullable))completion {}
@end

// MARK: - CBCModuleObserver

@interface CBCModuleObserverMock : XCTestCase <CBCModuleObserver>
@end

@implementation CBCModuleObserverMock
- (void)onModuleInitializationCompleted:(CBCModuleInitializationResult * _Nonnull)result {}
@end

// MARK: - PublicAPIStabilityObjCTests

/// Tests to validate that the Core SDK Objective-C public API remains stable and is not modified by mistake breaking existing integrations.
@interface PublicAPIStabilityObjCTests : XCTestCase
@end

@implementation PublicAPIStabilityObjCTests

/// Validates the AdvertisingEnvironment public APIs.
- (void)testAdvertisingEnvironment {
    id<CBCAdvertisingEnvironment> environment = ChartboostCore.advertisingEnvironment;
    ATTrackingManagerAuthorizationStatus appTrackingTransparencyStatus __unused = environment.appTrackingTransparencyStatus;
    NSString *advertisingID __unused = environment.advertisingID;
    NSString *bundleID __unused = environment.bundleID;
    NSString *deviceLocale __unused = environment.deviceLocale;
    NSString *deviceMake __unused = environment.deviceMake;
    NSString *deviceModel __unused = environment.deviceModel;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    BOOL isLimitAdTrackingEnabled __unused = environment.isLimitAdTrackingEnabled;
#pragma clang diagnostic pop
    NSString *osName __unused = environment.osName;
    NSString *osVersion __unused = environment.osVersion;
    double screenHeightPixels __unused = environment.screenHeightPixels;
    double screenScale __unused = environment.screenScale;
    double screenWidthPixels __unused = environment.screenWidthPixels;
}

/// Validates the AnalyticsEnvironment public APIs.
- (void)testAnalyticsEnvironment {
    id<CBCAnalyticsEnvironment> environment = ChartboostCore.analyticsEnvironment;
    ATTrackingManagerAuthorizationStatus appTrackingTransparencyStatus __unused = environment.appTrackingTransparencyStatus;
    NSTimeInterval appSessionDuration __unused = environment.appSessionDuration;
    NSString *appSessionID __unused = environment.appSessionID;
    NSString *appVersion __unused = environment.appVersion;
    NSString *advertisingID __unused = environment.advertisingID;
    NSString *bundleID __unused = environment.bundleID;
    NSString *deviceLocale __unused = environment.deviceLocale;
    NSString *deviceMake __unused = environment.deviceMake;
    NSString *deviceModel __unused = environment.deviceModel;
    NSString *frameworkName __unused = environment.frameworkName;
    NSString *frameworkVersion __unused = environment.frameworkVersion;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    BOOL isLimitAdTrackingEnabled __unused = environment.isLimitAdTrackingEnabled;
#pragma clang diagnostic pop
    BOOL isUserUnderage __unused = environment.isUserUnderage;
    CBCNetworkConnectionType networkConnectionType __unused = environment.networkConnectionType;
    NSString *osName __unused = environment.osName;
    NSString *osVersion __unused = environment.osVersion;
    NSString *playerID __unused = environment.playerID;
    NSString *publisherAppID __unused = environment.publisherAppID;
    NSString *publisherSessionID __unused = environment.publisherSessionID;
    double screenHeightPixels __unused = environment.screenHeightPixels;
    double screenScale __unused = environment.screenScale;
    double screenWidthPixels __unused = environment.screenWidthPixels;
    NSString *vendorID __unused = environment.vendorID;
    CBCVendorIDScope vendorIDScope __unused = environment.vendorIDScope;
    double volume __unused = environment.volume;
    [environment userAgentWithCompletion:^(NSString * _Nonnull userAgent) { }];

    id<CBCEnvironmentObserver> observer = nil;
    if (observer) {
        [environment addObserver:observer];
        [environment removeObserver:observer];
    }
}

/// Validates the AttributionEnvironment public APIs.
- (void)testAttributionEnvironment {
    id<CBCAttributionEnvironment> environment = ChartboostCore.attributionEnvironment;
    NSString *advertisingID __unused = environment.advertisingID;
    [environment userAgentWithCompletion:^(NSString * _Nonnull userAgent) { }];
}

/// Validates the ChartboostCore public APIs.
- (void)testChartboostCore {
    NSString *sdkVersion __unused = ChartboostCore.sdkVersion;
    CBCPublisherMetadata *publisherMetadata __unused = ChartboostCore.publisherMetadata;
    id<CBCAdvertisingEnvironment> advertisingEnvironment __unused = ChartboostCore.advertisingEnvironment;
    id<CBCAnalyticsEnvironment> analyticsEnvironment __unused = ChartboostCore.analyticsEnvironment;
    id<CBCAttributionEnvironment> attributionEnvironment __unused = ChartboostCore.attributionEnvironment;
    id<CBCConsentManagementPlatform> consent __unused = ChartboostCore.consent;
    id<CBCModule> module = [[CBCModuleMock alloc] initWithCredentials:nil];
    id<CBCModuleObserver> moduleObserver = [[CBCModuleObserverMock alloc] init];
    id<CBCLogHandler> logHandler = [[CBCLogHandlerMock alloc] init];

    CBCSDKConfiguration *config = [[CBCSDKConfiguration alloc] initWithChartboostAppID:@"some id"
                                                                               modules:@[module]
                                                                      skippedModuleIDs:@[@"some id"]];

    [ChartboostCore initializeSDKWithConfiguration:config moduleObserver:nil];
    [ChartboostCore initializeSDKWithConfiguration:config moduleObserver:moduleObserver];

    CBCLogLevel logLevel __unused = ChartboostCore.logLevel;
    ChartboostCore.logLevel = CBCLogLevelWarning;

    [ChartboostCore attachLogHandler:logHandler];
    [ChartboostCore detachLogHandler:logHandler];
}

/// Validates the CBCResult public APIs.
- (void)testChartboostCoreResult {
    CBCResult *result = nil;
    NSDate *startDate __unused = result.startDate;
    NSDate *endDate __unused = result.endDate;
    NSTimeInterval duration __unused = result.duration;
    NSError *error __unused = result.error;
}

/// Validates the ConsentDialogType public APIs.
- (void)testConsentAdapter {
    id<CBCConsentAdapter> consentAdapter __unused = [[CBCConsentAdapterMock alloc] initWithCredentials:@{@"": @{@"": @1}}];
    NSString *moduleID __unused = consentAdapter.moduleID;
    NSString *moduleVersion __unused = consentAdapter.moduleVersion;
    BOOL shouldCollectConsent __unused = consentAdapter.shouldCollectConsent;
    NSDictionary<NSString *,NSString *> *consents __unused = consentAdapter.consents;
    id<CBCConsentAdapterDelegate> delegate __unused = consentAdapter.delegate;
    consentAdapter.delegate = nil;

    CBCModuleConfiguration *moduleConfiguration = nil;
    [consentAdapter initializeWithConfiguration:moduleConfiguration completion:^(NSError * _Nullable error) {}];

    UIViewController *viewController = nil;
    [consentAdapter showConsentDialog:CBCConsentDialogTypeConcise from:viewController completion:^(BOOL result) {}];
    [consentAdapter grantConsentWithSource:CBCConsentSourceUser completion:^(BOOL result) {}];
    [consentAdapter denyConsentWithSource:CBCConsentSourceDeveloper completion:^(BOOL result) {}];
    [consentAdapter resetConsentWithCompletion:^(BOOL result) {}];
}

/// Validates the ConsentDialogType public APIs.
- (void)testConsentDialogType {
    CBCConsentDialogType concise __unused = CBCConsentDialogTypeConcise;
    CBCConsentDialogType detailed __unused = CBCConsentDialogTypeDetailed;
}

/// Validates the ConsentKey public APIs.
- (void)testConsentKey {
    NSString *consentKey = CBCConsentKeys.ccpaOptIn;
    consentKey = CBCConsentKeys.gdprConsentGiven;
    consentKey = CBCConsentKeys.gpp;
    consentKey = CBCConsentKeys.tcf;
    consentKey = CBCConsentKeys.usp;
    consentKey = @"custom standard";
}

/// Validates the ConsentManagementPlatform public APIs.
- (void)testConsentManagementPlatform {
    id<CBCConsentManagementPlatform> cmp = nil;
    BOOL shouldCollectConsent __unused = cmp.shouldCollectConsent;
    NSDictionary<NSString *, NSString *> *consents __unused = cmp.consents;
    id<CBCConsentObserver> consentObserver = [[CBCConsentObserverMock alloc] init];

    [cmp grantConsentWithSource:CBCConsentSourceUser completion:^(BOOL result){}];
    [cmp denyConsentWithSource:CBCConsentSourceDeveloper completion:^(BOOL result){}];
    [cmp resetConsentWithCompletion:^(BOOL result){}];

    [cmp showConsentDialog:CBCConsentDialogTypeConcise from:[[UIViewController alloc] init] completion:^(BOOL result){}];
    [cmp showConsentDialog:CBCConsentDialogTypeDetailed from:[[UIViewController alloc] init] completion:^(BOOL result){}];

    [cmp addObserver:consentObserver];
    [cmp removeObserver:consentObserver];
}

/// Validates the ConsentObserver public APIs.
- (void)testConsentObserver {
    id<CBCConsentObserver> observer;
    [observer onConsentModuleReadyWithInitialConsents:@{@"some key": @"some value"}];
    [observer onConsentChangeWithFullConsents:@{@"some key": @"some value"} modifiedKeys:[NSSet setWithObject:CBCConsentKeys.ccpaOptIn]];
    [observer onConsentChangeWithFullConsents:@{} modifiedKeys:[NSSet setWithObject:@"custom standard"]];
    [observer onConsentChangeWithFullConsents:@{CBCConsentKeys.ccpaOptIn: CBCConsentValues.denied} modifiedKeys:[[NSSet alloc] init]];
}

/// Validates the ConsentSource public APIs.
- (void)testConsentSource {
    CBCConsentSource source = CBCConsentSourceUser;
    source = CBCConsentSourceDeveloper;
}

/// Validates the ConsentValue public APIs.
- (void)testConsentValue {
    NSString *consentValue = CBCConsentValues.denied;
    consentValue = CBCConsentValues.doesNotApply;
    consentValue = CBCConsentValues.granted;
    consentValue = @"custom value";
}

/// Validates the ConsoleLogHandler public APIs.
- (void)testConsoleLogHandler {
    CBCConsoleLogHandler *consoleLogHandler = [[CBCConsoleLogHandler alloc] init];
    CBCLogLevel logLevel __unused = consoleLogHandler.logLevel;
    consoleLogHandler.logLevel = CBCLogLevelError;
    CBCLogEntry *logEntry;
    if (logEntry) {
        [consoleLogHandler handle:logEntry];
    }
}

/// Validates the EnvironmentObserver public APIs.
- (void)testEnvironmentObserver {
    id<CBCEnvironmentObserver> observer = nil;
    [observer onChange:CBCObservableEnvironmentPropertyPlayerID];
}

/// Validates the LogEntry public APIs.
- (void)testLogEntry {
    CBCLogEntry *logEntry = nil;
    NSString *message __unused = logEntry.message;
    NSString *subsystem __unused = logEntry.subsystem;
    NSString *category __unused = logEntry.category;
    NSDate *date __unused = logEntry.date;
    CBCLogLevel logLevel __unused = logEntry.logLevel;
}

/// Validates the Logger public APIs.
- (void)testLogger {
    CBCLogger *logger = [[CBCLogger alloc] initWithId:@"" name:@"" parent:nil];
    CBCLogger *logger2 __unused = [[CBCLogger alloc] initWithId:@"" name:@"" parent:logger];
    NSString *subsystem __unused = logger.subsystem;
    NSString *name __unused = logger.name;
    [logger attachHandler:[CBCLogHandlerMock new]];
    [logger detachHandler:[CBCLogHandlerMock new]];
    [logger verbose:@""];
    [logger debug:@""];
    [logger info:@""];
    [logger warning:@""];
    [logger error:@""];
    [logger log:@"" level:CBCLogLevelDebug];
}

/// Validates the LogHandler public APIs.
- (void)testLogHandler {
    id<CBCLogHandler> logHandler = nil;
    CBCLogEntry *logEntry = nil;
    if (logHandler) {
        [logHandler handle:logEntry];
    }
}

/// Validates the LogLevel public APIs.
- (void)testLogLevel {
    CBCLogLevel trace __unused = CBCLogLevelVerbose;
    CBCLogLevel debug __unused = CBCLogLevelDebug;
    CBCLogLevel info __unused = CBCLogLevelInfo;
    CBCLogLevel warning __unused = CBCLogLevelWarning;
    CBCLogLevel error __unused = CBCLogLevelError;
    CBCLogLevel none __unused = CBCLogLevelDisabled;
}

/// Validates the Module public APIs.
- (void)testModule {
    id<CBCModule> module = nil;
    NSString *moduleID __unused = module.moduleID;
    NSString *moduleVersion __unused = module.moduleVersion;

    CBCModuleConfiguration *config;
    if (config) {
        [module initializeWithConfiguration:config completion:^(NSError *error) {
            NSError *err __unused = error;
        }];
    }
}

/// Validates the ModuleConfiguration public APIs.
- (void)testModuleConfiguration {
    CBCModuleConfiguration *config = nil;
    NSString *chartboostAppID __unused = config.chartboostAppID;
}

/// Validates the ModuleInitializationResult public APIs.
- (void)testModuleInitializationResult {
    CBCModuleInitializationResult *result = nil;
    NSDate *startDate __unused = result.startDate;
    NSDate *endDate __unused = result.endDate;
    NSTimeInterval duration __unused = result.duration;
    NSError *error __unused = result.error;
    NSString *moduleID __unused = result.moduleID;
    NSString *moduleVersion __unused = result.moduleVersion;
}

/// Validates the ModuleFactory public API along with the associated private APIs consumed by Unity.
- (void)testModuleFactory {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    id<CBCModuleFactory> moduleFactory = [ChartboostCore performSelector:@selector(nonNativeModuleFactory)]; // test private getter
    [ChartboostCore performSelector:@selector(setNonNativeModuleFactory:) withObject:moduleFactory]; // test private setter
#pragma clang diagnostic pop
    [moduleFactory makeModuleWithClassName:@"class_name" credentials:nil completion:^(id<CBCModule> _Nullable module) {}];
    [moduleFactory makeModuleWithClassName:@"class_name" credentials:@{} completion:^(id<CBCModule> _Nullable module) {}];
}

/// Validates the ModuleObserver public APIs.
- (void)testModuleObserver {
    id<CBCModuleObserver> observer = nil;
    CBCModuleInitializationResult *result = nil;
    if (result) {
        [observer onModuleInitializationCompleted:result];
    }
}

/// Validates the NetworkConnectionType public APIs.
- (void)testNetworkConnectionType {
    CBCNetworkConnectionType connectionType = CBCNetworkConnectionTypeUnknown;
    connectionType = CBCNetworkConnectionTypeWired;
    connectionType = CBCNetworkConnectionTypeWifi;
    connectionType = CBCNetworkConnectionTypeCellularUnknown;
    connectionType = CBCNetworkConnectionTypeCellular2G;
    connectionType = CBCNetworkConnectionTypeCellular3G;
    connectionType = CBCNetworkConnectionTypeCellular4G;
    connectionType = CBCNetworkConnectionTypeCellular5G;
}

/// Validates the ObservableEnvironmentProperty public APIs.
- (void)testObservableEnvironmentProperty {
    CBCObservableEnvironmentProperty property = CBCObservableEnvironmentPropertyFrameworkName;
    property = CBCObservableEnvironmentPropertyFrameworkVersion;
    property = CBCObservableEnvironmentPropertyIsUserUnderage;
    property = CBCObservableEnvironmentPropertyPlayerID;
    property = CBCObservableEnvironmentPropertyPublisherAppID;
    property = CBCObservableEnvironmentPropertyPublisherSessionID;
}

/// Validates the PublisherMetadata public APIs.
- (void)testPublisherMetadata {
    CBCPublisherMetadata *publisherMetadata = ChartboostCore.publisherMetadata;
    [publisherMetadata setFrameworkWithName:@"" version:@"" ];
    [publisherMetadata setIsUserUnderage:YES];
    [publisherMetadata setPublisherAppID:@""];
    [publisherMetadata setPlayerID:@""];
    [publisherMetadata setPublisherSessionID:@""];
}

/// Validates the SDKConfiguration public APIs.
- (void)testSDKConfiguration {
    id<CBCModule> module = [[CBCModuleMock alloc] initWithCredentials:nil];
    CBCSDKConfiguration *configuration = [[CBCSDKConfiguration alloc] initWithChartboostAppID:@"some id"
                                                                                      modules:@[module]
                                                                             skippedModuleIDs:@[@"some id"]];
    NSString *chartboostAppID __unused = configuration.chartboostAppID;
    NSArray<id<CBCModule>> *modules __unused = configuration.modules;
    NSArray<NSString *> *skippedModuleIDs __unused = configuration.skippedModuleIDs;
}

/// Validates the VendorIDScope public APIs.
- (void)testVendorIDScope {
    CBCVendorIDScope vendorIDScope = CBCVendorIDScopeUnknown;
    vendorIDScope = CBCVendorIDScopeApplication;
    vendorIDScope = CBCVendorIDScopeDeveloper;
}

@end
