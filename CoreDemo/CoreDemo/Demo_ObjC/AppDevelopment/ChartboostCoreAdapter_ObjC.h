// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@import ChartboostCoreSDK;

NS_ASSUME_NONNULL_BEGIN

/// Code demo for how to use the `ChartboostCore` SDK.
@interface ChartboostCoreAdapter_ObjC : NSObject

+ (instancetype)sharedInstance;

/// Initialize the `ChartboostCore` SDK with hardcoded parameters.
- (void)initializeSDK;

- (void)resetConsent;

- (void)denyConsent;

- (void)grantConsent;

- (void)showConsentDialog:(CBCConsentDialogType)consentDialogType from:(UIViewController *)viewController;

@end

@interface ChartboostCoreAdapter_ObjC (ConsentObserver) <CBCConsentObserver>
@end

@interface ChartboostCoreAdapter_ObjC (ModuleObserver) <CBCInitializableModuleObserver>
@end

NS_ASSUME_NONNULL_END
