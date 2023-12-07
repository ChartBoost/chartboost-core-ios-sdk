// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@import AppTrackingTransparency;
@import ChartboostCoreSDK;
@import XCTest;

/// Tests to validate that the Core SDK Objective-C public API remains stable and is not modified by mistake breaking existing integrations.
@interface PublicAPIStabilityObjCTests : XCTestCase
<
    CBCConsentManagementPlatform,
    CBCConsentObserver,
    CBCInitializableModule,
    CBCInitializableModuleObserver,
    CBCLogHandler
>

@end

@implementation PublicAPIStabilityObjCTests

/// Validates the AdvertisingEnvironment public APIs.
- (void)testAdvertisingEnvironment {
    id<CBCAdvertisingEnvironment> environment = ChartboostCore.advertisingEnvironment;
    NSString *advertisingID __unused = environment.advertisingID;
    NSString *bundleID __unused = environment.bundleID;
    NSString *deviceLocale __unused = environment.deviceLocale;
    NSString *deviceMake __unused = environment.deviceMake;
    NSString *deviceModel __unused = environment.deviceModel;
    BOOL isLimitAdTrackingEnabled __unused = environment.isLimitAdTrackingEnabled;
    NSString *osName __unused = environment.osName;
    NSString *osVersion __unused = environment.osVersion;
    double screenHeight __unused = environment.screenHeight;
    double screenScale __unused = environment.screenScale;
    double screenWidth __unused = environment.screenWidth;
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
    BOOL isLimitAdTrackingEnabled __unused = environment.isLimitAdTrackingEnabled;
    BOOL isUserUnderage __unused = environment.isUserUnderage;
    CBCNetworkConnectionType networkConnectionType __unused = environment.networkConnectionType;
    NSString *osName __unused = environment.osName;
    NSString *osVersion __unused = environment.osVersion;
    NSString *playerID __unused = environment.playerID;
    NSString *publisherAppID __unused = environment.publisherAppID;
    NSString *publisherSessionID __unused = environment.publisherSessionID;
    double screenHeight __unused = environment.screenHeight;
    double screenScale __unused = environment.screenScale;
    double screenWidth __unused = environment.screenWidth;
    NSString *vendorID __unused = environment.vendorID;
    CBCVendorIDScope vendorIDScope __unused = environment.vendorIDScope;
    double volume __unused = environment.volume;
    [environment userAgentWithCompletion:^(NSString * _Nonnull userAgent) { }];
}

/// Validates the AttributionEnvironment public APIs.
- (void)testAttributionEnvironment {
    id<CBCAttributionEnvironment> environment = ChartboostCore.attributionEnvironment;
    NSString *advertisingID __unused = environment.advertisingID;
    [environment userAgentWithCompletion:^(NSString * _Nonnull userAgent) { }];
}

/// Validates the ChartboostCore public APIs.
- (void)testChartboostCore {
    CBCPublisherMetadata *publisherMetadata __unused = ChartboostCore.publisherMetadata;
    id<CBCAdvertisingEnvironment> advertisingEnvironment __unused = ChartboostCore.advertisingEnvironment;
    id<CBCAnalyticsEnvironment> analyticsEnvironment __unused = ChartboostCore.analyticsEnvironment;
    id<CBCAttributionEnvironment> attributionEnvironment __unused = ChartboostCore.attributionEnvironment;
    id<CBCConsentManagementPlatform> consent __unused = ChartboostCore.consent;
    NSString *sdkVersion __unused = ChartboostCore.sdkVersion;

    [ChartboostCore initializeSDKWithConfiguration:[[CBCSDKConfiguration alloc] initWithChartboostAppID:@""]
                                           modules:@[]
                                    moduleObserver:nil];
    [ChartboostCore initializeSDKWithConfiguration:[[CBCSDKConfiguration alloc] initWithChartboostAppID:@""]
                                    moduleObserver:nil];
    [ChartboostCore initializeSDKWithConfiguration:[[CBCSDKConfiguration alloc] initWithChartboostAppID:@""]
                                           modules:@[self]
                                    moduleObserver:self];

    CBCLogLevel logLevel __unused = ChartboostCore.logLevel;
    ChartboostCore.logLevel = CBCLogLevelWarning;

    [ChartboostCore attachLogHandler:self];
    [ChartboostCore detachLogHandler:self];
}

/// Validates the CBCResult public APIs.
- (void)testCBCResult {
    CBCResult *result = nil;
    NSDate *startDate __unused = result.startDate;
    NSDate *endDate __unused = result.endDate;
    NSTimeInterval duration __unused = result.duration;
    NSError *error __unused = result.error;
}

/// Validates the ConsentDialogType public APIs.
- (void)testConsentDialogType {
    CBCConsentDialogType concise __unused = CBCConsentDialogTypeConcise;
    CBCConsentDialogType detailed __unused = CBCConsentDialogTypeDetailed;
}

/// Validates the ConsentManagementPlatform public APIs.
- (void)testConsentManagementPlatform {
    id<CBCConsentManagementPlatform> cmp = nil;
    BOOL shouldCollectConsent __unused = cmp.shouldCollectConsent;
    CBCConsentStatus consentStatus __unused = cmp.consentStatus;
    NSDictionary<NSString *, NSNumber *> *partnerConsentStatus __unused = cmp.objc_partnerConsentStatus;
    NSDictionary<CBCConsentStandard *, CBCConsentValue *> *consents __unused = cmp.consents;

    [cmp grantConsentWithSource:CBCConsentStatusSourceUser completion:^(BOOL result){}];
    [cmp denyConsentWithSource:CBCConsentStatusSourceDeveloper completion:^(BOOL result){}];
    [cmp resetConsentWithCompletion:^(BOOL result){}];

    [cmp showConsentDialog:CBCConsentDialogTypeConcise from:[[UIViewController alloc] init] completion:^(BOOL result){}];
    [cmp showConsentDialog:CBCConsentDialogTypeDetailed from:[[UIViewController alloc] init] completion:^(BOOL result){}];

    [cmp addObserver:self];
    [cmp removeObserver:self];
}

/// Validates the ConsentObserver public APIs.
- (void)testConsentObserver {
    id<CBCConsentObserver> observer;
    [observer onConsentModuleReady];
    [observer onPartnerConsentStatusChangeWithPartnerID:@"some partner ID" status:CBCConsentStatusGranted];
    [observer onConsentChangeWithStandard:CBCConsentStandard.ccpaOptIn value:[[CBCConsentValue alloc] initWithStringLiteral:@"some value"]];
    [observer onConsentChangeWithStandard:[[CBCConsentStandard alloc] initWithStringLiteral:@"custom standard"] value:CBCConsentValue.denied];
    [observer onConsentStatusChange:CBCConsentStatusDenied];
}

/// Validates the ConsentStandard public APIs.
- (void)testConsentStandard {
    CBCConsentStandard *consentStandard = CBCConsentStandard.ccpaOptIn;
    consentStandard = CBCConsentStandard.gdprConsentGiven;
    consentStandard = CBCConsentStandard.gpp;
    consentStandard = CBCConsentStandard.tcf;
    consentStandard = CBCConsentStandard.usp;

    consentStandard = [[CBCConsentStandard alloc] initWithStringLiteral:@"custom standard"];
    NSString *standard = @"custom standard";
    consentStandard = [[CBCConsentStandard alloc] initWithStringLiteral:standard];

    NSString *description __unused = CBCConsentStandard.ccpaOptIn.description;
}

/// Validates the ConsentStatus public APIs.
- (void)testConsentStatus {
    CBCConsentStatus consentStatus = CBCConsentStatusUnknown;
    consentStatus = CBCConsentStatusDenied;
    consentStatus = CBCConsentStatusGranted;
}

/// Validates the ConsentStatusSource public APIs.
- (void)testConsentStatusSource {
    CBCConsentStatusSource source = CBCConsentStatusSourceUser;
    source = CBCConsentStatusSourceDeveloper;
}

/// Validates the ConsentValue public APIs.
- (void)testConsentValue {
    CBCConsentValue *consentValue = CBCConsentValue.denied;
    consentValue = CBCConsentValue.doesNotApply;
    consentValue = CBCConsentValue.granted;

    consentValue = [[CBCConsentValue alloc] initWithStringLiteral:@"custom value"];
    NSString *value = @"custom value";
    consentValue = [[CBCConsentValue alloc] initWithStringLiteral:value];

    NSString *description __unused = CBCConsentValue.granted.description;
}

/// Validates the InitializableModule public APIs.
- (void)testInitializableModule {
    id<CBCInitializableModule> module = nil;
    NSString *moduleID __unused = module.moduleID;
    NSString *moduleVersion __unused = module.moduleVersion;

    CBCModuleInitializationConfiguration *config;
    if (config) {
        [module initializeWithConfiguration:config completion:^(NSError *error) {
            NSError *err __unused = error;
        }];
    }
}

/// Validates the InitializableModuleObserver public APIs.
- (void)testInitializableModuleObserver {
    id<CBCInitializableModuleObserver> observer = nil;
    CBCModuleInitializationResult *result = nil;
    if (result) {
        [observer onModuleInitializationCompleted:result];
    }
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

/// Validates the LogLevel public APIs.
- (void)testLogLevel {
    CBCLogLevel trace __unused = CBCLogLevelTrace;
    CBCLogLevel debug __unused = CBCLogLevelDebug;
    CBCLogLevel info __unused = CBCLogLevelInfo;
    CBCLogLevel warning __unused = CBCLogLevelWarning;
    CBCLogLevel error __unused = CBCLogLevelError;
    CBCLogLevel none __unused = CBCLogLevelNone;
}

/// Validates the LogHandler public APIs.
- (void)testLogHandler {
    id<CBCLogHandler> logHandler = nil;
    CBCLogEntry *logEntry = nil;
    if (logHandler) {
        [logHandler handle:logEntry];
    }
}

/// Validates the ModuleInitializationConfiguration public APIs.
- (void)testModuleInitializationConfiguration {
    CBCModuleInitializationConfiguration *config = nil;
    NSString *chartboostAppID __unused = config.chartboostAppID;
}

/// Validates the ModuleInitializationResult public APIs.
- (void)testModuleInitializationResult {
    CBCModuleInitializationResult *result = nil;
    NSDate *startDate __unused = result.startDate;
    NSDate *endDate __unused = result.endDate;
    NSTimeInterval duration __unused = result.duration;
    NSError *error __unused = result.error;
    id<CBCInitializableModule> module __unused = result.module;
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

/// Validates the PublisherMetadata public APIs.
- (void)testPublisherMetadata {
    CBCPublisherMetadata *publisherMetadata = ChartboostCore.publisherMetadata;
    [publisherMetadata setFrameworkName:@""];
    [publisherMetadata setFrameworkVersion:@""];
    [publisherMetadata setIsUserUnderage:YES];
    [publisherMetadata setPublisherAppID:@""];
    [publisherMetadata setPlayerID:@""];
    [publisherMetadata setPublisherSessionID:@""];
    id<CBCPublisherMetadataObserver> observer = nil;
    if (observer) {
        [publisherMetadata addObserver:observer];
        [publisherMetadata removeObserver:observer];
    }
}

/// Validates the PublisherMetadataObserver public APIs.
- (void)testPublisherMetadataObserver {
    id<CBCPublisherMetadataObserver> observer = nil;
    [observer onChange:CBCPublisherMetadataPropertyPlayerID];
}

/// Validates the PublisherMetadata.Property public APIs.
- (void)testPublisherMetadataProperty {
    CBCPublisherMetadataProperty property = CBCPublisherMetadataPropertyFrameworkName;
    property = CBCPublisherMetadataPropertyFrameworkVersion;
    property = CBCPublisherMetadataPropertyIsUserUnderage;
    property = CBCPublisherMetadataPropertyPlayerID;
    property = CBCPublisherMetadataPropertyPublisherAppID;
    property = CBCPublisherMetadataPropertyPublisherSessionID;
}

/// Validates the SDKConfiguration public APIs.
- (void)testSDKConfiguration {
    CBCSDKConfiguration *configuration = [[CBCSDKConfiguration alloc] initWithChartboostAppID:@"some id"];
    NSString *chartboostAppID __unused = configuration.chartboostAppID;
}

/// Validates the VendorIDScope public APIs.
- (void)testVendorIDScope {
    CBCVendorIDScope vendorIDScope = CBCVendorIDScopeUnknown;
    vendorIDScope = CBCVendorIDScopeApplication;
    vendorIDScope = CBCVendorIDScopeDeveloper;
}

// MARK: ChartboostCoreConsentObserver

- (void)onConsentModuleReady {

}

- (void)onConsentStatusChange:(CBCConsentStatus)status {

}

- (void)onPartnerConsentStatusChangeWithPartnerID:(NSString *)partnerID status:(enum CBCConsentStatus)status {

}

- (void)onConsentChangeWithStandard:(CBCConsentStandard *)standard value:(CBCConsentValue *)value {

}

// MARK: CBCInitializableModuleObserver

- (void)onModuleInitializationCompleted:(CBCModuleInitializationResult *)result {

}

// MARK: CBCInitializableModule

- (NSString *)moduleID {
    return @"";
}

- (NSString *)moduleVersion {
    return @"";
}

- (instancetype)initWithCredentials:(NSDictionary<NSString *,id> *)credentials {
    return [super init];
}

- (void)initializeWithConfiguration:(CBCModuleInitializationConfiguration * _Nonnull)configuration 
                         completion:(void (^ _Nonnull)(NSError * _Nullable))completion {

}

// MARK: CBCConsentManagementPlatform

- (BOOL)shouldCollectConsent {
    return NO;
}

- (CBCConsentStatus)consentStatus {
    return CBCConsentStatusDenied;
}

- (NSDictionary<NSString *, NSNumber *> *)objc_partnerConsentStatus {
    return @{};
}

-(NSDictionary<CBCConsentStandard *, CBCConsentValue *> *)consents {
    return @{CBCConsentStandard.ccpaOptIn: CBCConsentValue.denied};
}

- (void)grantConsentWithSource:(enum CBCConsentStatusSource)source completion:(void (^)(BOOL))completion {

}

- (void)denyConsentWithSource:(enum CBCConsentStatusSource)source completion:(void (^)(BOOL))completion {

}

- (void)resetConsentWithCompletion:(void (^)(BOOL))completion {

}

- (void)showConsentDialog:(enum CBCConsentDialogType)type from:(UIViewController *)viewController completion:(void (^)(BOOL))completion {

}

- (void)addObserver:(id<CBCConsentObserver>)observer {

}

- (void)removeObserver:(id<CBCConsentObserver>)observer {

}

// MARK: CBCPublisherMetadataObserver

- (void)onChange:(enum CBCPublisherMetadataProperty)property {

}

// MARK: CBCLogHandler

- (void)handle:(CBCLogEntry *)entry {

}

@end
