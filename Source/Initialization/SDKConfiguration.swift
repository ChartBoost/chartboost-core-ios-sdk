// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Configuration with parameters needed by the Chartboost Core SDK on initialization.
@objc(CBCSDKConfiguration)
@objcMembers
public final class SDKConfiguration: NSObject {
    /// The Chartboost App ID which should match the value on the Chartboost dashboard.
    /// After the first successful initialization of Chartboost Core SDK, the `chartboostAppID` in subsequent
    /// ``ChartboostCore/initializeSDK(configuration:moduleObserver:)`` calls will be ignored.
    public let chartboostAppID: String

    /// Optional list of modules to be initialized and managed by the Core SDK.
    /// In addition to these `moduels`, SDK fetches a list of modules to initialize along SDK initialization.
    /// Modules already defined on Chartboost Core's dashboard do not need to be provided here, otherwise
    /// the fetched duplicates are skipped.
    public let modules: [Module]

    /// Identifiers of modules that should not be initialized along SDK initialization.
    /// Modules are not initialized along SDK initialization if their module IDs are on this list.
    /// This is typically used for deferring the initialization of fetched modules defined on Chartboost Core's
    /// dashboard, but it's also effective against the `modules` in this SDK configuration.
    /// Skipped modules do not trigger any ``ModuleObserver`` callback.
    public let skippedModuleIDs: [String]

    /// Initializes a configuration object.
    /// - parameter chartboostAppID: The Chartboost App ID which should match the value on the Chartboost dashboard.
    /// - parameter modules: Optional list of modules to be initialized and managed by the Core SDK.
    /// - parameter skippedModuleIDs: Identifiers of modules that should not be initialized along SDK initialization.
    public init(
        chartboostAppID: String,
        modules: [Module] = [],
        skippedModuleIDs: [String] = []
    ) {
        self.chartboostAppID = chartboostAppID
        self.modules = modules
        self.skippedModuleIDs = skippedModuleIDs
    }

    @available(*, unavailable)
    override init() {
        fatalError("init() has not been implemented")
    }
}
