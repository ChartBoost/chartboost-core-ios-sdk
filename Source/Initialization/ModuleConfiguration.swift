// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Configuration with parameters needed by ``Module`` on initialization.
@objc(CBCModuleConfiguration)
@objcMembers
public final class ModuleConfiguration: NSObject {
    /// The Chartboost App ID which should match the value on the Chartboost dashboard.
    public let chartboostAppID: String

    /// Initializes a configuration object.
    /// - parameter chartboostAppID: The Chartboost App ID which should match the value on the Chartboost dashboard.
    init(sdkConfiguration: SDKConfiguration) {
        chartboostAppID = sdkConfiguration.chartboostAppID
    }

    // Prevent users from instantiating this class.
    @available(*, unavailable)
    override init() {
        fatalError("init() has not been implemented")
    }
}
