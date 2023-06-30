// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

@objc(ChartboostCoreSDKInitializationResult)
@objcMembers
public final class SDKInitializationResult: ChartboostCoreResult {
    public let isSDKInitialized: Bool

    internal init(
        startDate: Date,
        endDate: Date = Date(),
        error: Error?,
        isSDKInitialized: Bool
    ) {
        self.isSDKInitialized = isSDKInitialized
        super.init(startDate: startDate, endDate: endDate, error: error)
    }
}
