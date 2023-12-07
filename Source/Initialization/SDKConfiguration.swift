// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Configuration with parameters needed by the Chartboost Core SDK on initialization.
@objc(CBCSDKConfiguration)
@objcMembers
public final class SDKConfiguration: NSObject {

    /// The Chartboost App ID which should match the value on the Chartboost dashboard.
    public let chartboostAppID: String

    /// Initializes a configuration object.
    /// - parameter chartboostAppID: The Chartboost App ID which should match the value on the Chartboost dashboard.
    public init(chartboostAppID: String) {
        self.chartboostAppID = chartboostAppID
    }

    // Make NSObject init private to prevent users from instantiating this class.
    override private init() {
        self.chartboostAppID = ""
    }
}
