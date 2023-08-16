// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@import ChartboostCoreSDK;

NS_ASSUME_NONNULL_BEGIN

/// Code demo for how to create a custom module that conforms to the `CBCInitializableModule` protocol.
@interface CustomInitializableModule_ObjC : NSObject

// Some custom values for this module.
@property (nonatomic, nullable, readonly) NSString *customString;
@property (nonatomic, nullable, readonly) NSNumber *customNumber;

// The custom `init` for custom values when instantiated by the client side business logic.
- (instancetype)initWithString:(NSString *)string andNumber:(NSNumber *)number;

@end

@interface CustomInitializableModule_ObjC (CBCInitializableModule) <CBCInitializableModule>
@end

NS_ASSUME_NONNULL_END
