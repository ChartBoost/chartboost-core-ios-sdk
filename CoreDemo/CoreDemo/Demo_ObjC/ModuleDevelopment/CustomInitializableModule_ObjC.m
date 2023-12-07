// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import "CustomInitializableModule_ObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomInitializableModule_ObjC ()

// Some custom values for this module.
@property (nonatomic, nullable) NSString *customString;
@property (nonatomic, nullable) NSNumber *customNumber;

// For `CBCInitializableModule`.
@property (nonatomic, nullable) NSDictionary<NSString *, id> *credentials;

@end

#pragma mark -

@implementation CustomInitializableModule_ObjC

// The custom `init` for custom values when instantiated by the client side business logic.
- (instancetype)initWithString:(NSString *)string andNumber:(NSNumber *)number {
    if (self = [super init]) {
        _customString = string;
        _customNumber = number;
        _credentials = nil;
    }
    return self;
}

@end

#pragma mark -

@implementation CustomInitializableModule_ObjC (CBCInitializableModule)

- (NSString *)moduleID {
    return @"custom_module_objc";
}

- (NSString *)moduleVersion {
    return @"1.0.0";
}

// The `InitializableModule` required `init` when instantiated via reflection by the backend configuration.
- (instancetype)initWithCredentials:(NSDictionary<NSString *, id> * _Nullable)credentials {
    if (self = [super init]) {
        _customString = nil;
        _customNumber = nil;
        _credentials = credentials;
    }
    return self;
}

// The `ChartboostCore` SDK calls this to initialize the module.
- (void)initializeWithConfiguration:(CBCModuleInitializationConfiguration * _Nonnull)configuration completion:(void (^ _Nonnull)(NSError * _Nullable))completion {
    BOOL errorHappend = arc4random_uniform(2) == 1;

    if (errorHappend) {
        // Report an error if something went wrong.
        // The `ChartboostCore` SDK will retry a few times before reporting the error to
        // `InitializableModuleObserver` via the `onModuleInitializationCompleted()`
        // callback.
        // In this demo, initialization is very likely to be successful within a few retries.
        completion([NSError errorWithDomain:@"YOUR_ERROR_DOMAIN"
                                       code:123
                                   userInfo:nil]);
    } else {
        // Report success to the `ChartboostCore` SDK.
        completion(nil);
    }
}

@end

NS_ASSUME_NONNULL_END
