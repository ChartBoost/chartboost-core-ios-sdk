// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

@objc(ChartboostCoreSDKConfiguration)
@objcMembers
public final class SDKConfiguration: NSObject {

    public let chartboostAppID: String

    public init(chartboostAppID: String) {
        self.chartboostAppID = chartboostAppID
    }
}
