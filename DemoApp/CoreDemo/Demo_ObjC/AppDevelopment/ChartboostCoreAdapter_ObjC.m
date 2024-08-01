// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@import ChartboostCoreConsentAdapterUsercentrics;
@import ChartboostCoreSDK;
@import Usercentrics;

#import <CoreDemo-Swift.h>

#import "ChartboostCoreAdapter_ObjC.h"
#import "CustomModule_ObjC.h"

NS_ASSUME_NONNULL_BEGIN

NSString * ConsentDialogTypeAsString(CBCConsentDialogType consentDialogType) {
    switch (consentDialogType) {
        case CBCConsentDialogTypeConcise:
            return @"concise";
        case CBCConsentDialogTypeDetailed:
            return @"detailed";
    }
}

@implementation ChartboostCoreAdapter_ObjC

+ (instancetype)sharedInstance
{
    static ChartboostCoreAdapter_ObjC *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ChartboostCoreAdapter_ObjC alloc] init];
    });
    return sharedInstance;
}

- (void)initializeSDK {
    // This demo uses the Usercentrics SDK as the CMP (Consent Management Platform) SDK, which
    // is wrapped by a Chartboost developed adapter `CBCUsercentricsAdapter`.
    //
    // You can choose any CMP SDK of your choice, wrap it with an adapter that conforms to
    // the `CCBConsentAdapter` protocol, and assign it to the `cmpModule` here.
    //
    // Note: The Usercentrics SDK does not work without a valid Settings ID.
    CBCUsercentricsAdapter *cmpModule
        = [[CBCUsercentricsAdapter alloc] initWithOptions:[[UsercentricsUsercentricsOptions alloc] initWithSettingsId:@"your_usercentrics_settings_id"]];

    CustomModule_ObjC *customModule_ObjC
        = [[CustomModule_ObjC alloc] initWithString:@"some value 1" andNumber:@123];

    CustomModule_Swift *customModule_Swift
        = [[CustomModule_Swift alloc] initWithCustomString:@"some value 2" customNumber:234];

    // Configurate the ChartboostCore SDK with a Chartboost App ID and Core modules.
    CBCSDKConfiguration *sdkConfig
        = [[CBCSDKConfiguration alloc] initWithChartboostAppID:@"your_chartboost_app_id"
                                                       modules:@[cmpModule, customModule_ObjC, customModule_Swift]
                                              skippedModuleIDs:@[]];

    // Add a `CBCConsentObserver` observer (which is `self` in this demo) to receive consent update
    // callbacks after the user denied or granted consent.
    // Consent observer can be added before or after the `initializeSDK` call.
    // Adding the same observer multiple times does not multiplex the callbacks.
    [ChartboostCore.consent addObserver:self];

    // The `modules` array should container one and only one CMP (Consent Management Platform) module.
    // If multiple CMP modules (`CBCConsentAdapter`) are provided, only the first one will be initialized
    // with the other CMP modules ignored.
    //
    // This call initializes the Chartboost Core SDK. Although `moduleObserver` is optional, providing
    // a `CBCModuleObserver` is very helpful for receiving callbacks to know whether the
    // provided modules were initilized successfully.
    [ChartboostCore initializeSDKWithConfiguration:sdkConfig
                                    moduleObserver:ChartboostCoreAdapter_ObjC.sharedInstance];
}

- (void)resetConsent {
    [ChartboostCore.consent resetConsentWithCompletion:^(BOOL succeeded) {
        LogItem *log = [[LogItem alloc]
                        initWithText:@"[ObjC] Reset consent"
                        secondaryText:[NSString stringWithFormat:
                                       @"Result: succeeded = %@",
                                       succeeded ? @"true" : @"false"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification.NewLog object:log];
    }];
}

- (void)denyConsent {
    [ChartboostCore.consent denyConsentWithSource:CBCConsentSourceUser completion:^(BOOL succeeded) {
        LogItem *log = [[LogItem alloc]
                        initWithText:@"[ObjC] Deny consent"
                        secondaryText:[NSString stringWithFormat:
                                       @"Result: succeeded = %@",
                                       succeeded ? @"true" : @"false"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification.NewLog object:log];
    }];
}

- (void)grantConsent {
    [ChartboostCore.consent grantConsentWithSource:CBCConsentSourceUser completion:^(BOOL succeeded) {
        LogItem *log = [[LogItem alloc]
                        initWithText:@"[ObjC] Grant consent"
                        secondaryText:[NSString stringWithFormat:
                                       @"Result: succeeded = %@",
                                       succeeded ? @"true" : @"false"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification.NewLog object:log];
    }];
}

- (void)showConsentDialog:(CBCConsentDialogType)consentDialogType from:(UIViewController *)viewController {
    [ChartboostCore.consent showConsentDialog:consentDialogType from:viewController completion:^(BOOL succeeded) {
        LogItem *log = [[LogItem alloc]
                        initWithText:[NSString stringWithFormat:
                                      @"[ObjC] Show consent dialog: %@",
                                      ConsentDialogTypeAsString(consentDialogType)]
                        secondaryText:[NSString stringWithFormat:
                                       @"Result: succeeded = %@", succeeded ? @"true" : @"false"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification.NewLog object:log];
    }];
}

@end

#pragma mark -

@implementation ChartboostCoreAdapter_ObjC (ConsentObserver)

- (void)onConsentModuleReadyWithInitialConsents:(NSDictionary<NSString *,NSString *> *)initialConsents {
    LogItem *log = [[LogItem alloc]
                    initWithText:@"[ObjC] onConsentModuleReady"
                    secondaryText:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification.NewLog object:log];
}

- (void)onConsentChangeWithFullConsents:(NSDictionary<NSString *,NSString *> *)fullConsents
                           modifiedKeys:(NSSet<NSString *> *)modifiedKeys {
    LogItem *log = [[LogItem alloc]
                    initWithText:@"[ObjC] onConsentChange"
                    secondaryText:[NSString stringWithFormat:@"ConsentKeys: %@", [[modifiedKeys allObjects] componentsJoinedByString:@", "]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification.NewLog object:log];
}

@end

#pragma mark -

@implementation ChartboostCoreAdapter_ObjC (ModuleObserver)

- (void)onModuleInitializationCompleted:(CBCModuleInitializationResult * _Nonnull)result {
    LogItem *log = [[LogItem alloc]
                    initWithText:[NSString stringWithFormat:
                                  @"[ObjC] Module init: %@",
                                  result.moduleID]
                    secondaryText:[NSString stringWithFormat:
                                   @"Result: error = %@",
                                   result.error.localizedDescription ?: @"nil"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification.NewLog object:log];
}

@end

NS_ASSUME_NONNULL_END
