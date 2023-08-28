// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@import AppTrackingTransparency;
@import ChartboostCoreSDK;
@import XCTest;

/// Tests to validate that the Core SDK Objective-C public API remains stable and is not modified by mistake breaking existing integrations.
@interface PublicAPIStabilityObjCTests : XCTestCase
<
    CBCConsentAdapter,
    CBCConsentManagementPlatform,
    CBCConsentObserver,
    CBCInitializableModule,
    CBCInitializableModuleObserver
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
}

/// Validates the CBCResult public APIs.
- (void)testCBCResult {
    CBCResult *result = nil;
    NSDate *startDate __unused = result.startDate;
    NSDate *endDate __unused = result.endDate;
    NSTimeInterval duration __unused = result.duration;
    NSError *error __unused = result.error;
}

/// Validates the ConsentAdapter public APIs.
- (void)testConsentAdapter {
    id<CBCConsentAdapter> adapter = nil;
    BOOL shouldCollectConsent __unused = adapter.shouldCollectConsent;
    CBCConsentStatus consentStatus __unused = adapter.consentStatus;
    NSDictionary<CBCConsentStandard *, CBCConsentValue *> *consents __unused = adapter.consents;

    id<CBCConsentAdapterDelegate> delegate __unused = adapter.delegate;
    adapter.delegate = delegate;
    adapter.delegate = nil;


    [adapter grantConsentWithSource:CBCConsentStatusSourceUser completion:^(BOOL result){}];
    [adapter denyConsentWithSource:CBCConsentStatusSourceDeveloper completion:^(BOOL result){}];
    [adapter resetConsentWithCompletion:^(BOOL result){}];

    [adapter showConsentDialog:CBCConsentDialogTypeConcise from:[[UIViewController alloc] init] completion:^(BOOL result){}];
    [adapter showConsentDialog:CBCConsentDialogTypeDetailed from:[[UIViewController alloc] init] completion:^(BOOL result){}];

    NSString *moduleName __unused = adapter.moduleID;
    NSString *moduleVersion __unused = adapter.moduleVersion;

    [adapter initializeWithCompletion:^(NSError *error) {
        NSError *err __unused = error;
    }];
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

    [module initializeWithCompletion:^(NSError *error) {
        NSError *err __unused = error;
    }];
}

/// Validates the InitializableModuleObserver public APIs.
- (void)testInitializableModuleObserver {
    id<CBCInitializableModuleObserver> observer = nil;
    CBCModuleInitializationResult *result = nil;
    if (result) {
        [observer onModuleInitializationCompleted:result];
    }
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

- (void)initializeWithCompletion:(void (^ _Nonnull)(NSError * _Nullable))completion {

}

// MARK: CBCConsentAdapter

- (void)setDelegate:(id<CBCConsentAdapterDelegate>)delegate {

}

- (id<CBCConsentAdapterDelegate>)delegate {
    return nil;
}

// MARK: CBCConsentManagementPlatform

- (BOOL)shouldCollectConsent {
    return NO;
}

- (CBCConsentStatus)consentStatus {
    return CBCConsentStatusDenied;
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

@end
