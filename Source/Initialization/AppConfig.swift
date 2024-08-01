// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Internal representation of the app config defined on the backend.
struct AppConfig: Codable, Equatable {
    /// Backend-defined module information to be used on initialization.
    struct ModuleInfo: Codable, Equatable {
        /// The module class name, used to instantiate the module via reflection.
        let className: String?

        /// The non-native module class name, used by a ``ModuleFactory`` to instantiate the non-native module
        /// via reflection.
        let nonNativeClassName: String?

        /// The module identifier.
        let identifier: String

        /// The dictionary to pass to the module on init when instantiated via reflection.
        let credentials: JSON<[String: Any]>?
    }

    /// The Chartboost App ID used to retrieve the config.
    /// It should only be nil for the default client-side config.
    let chartboostAppID: String?

    /// The delay to apply to consent updates forwarded to ``ConsentObserver`` instances,
    /// so quick successive updates are batched into a single one.
    /// A value of `0` will disable batching.
    let consentUpdateBatchDelay: TimeInterval

    /// The base value to use when scheduling a retry of the Core SDK initialization.
    /// See ``Math.retryDelayInterval(retryNumber:base:limit:)`` for more info.
    let coreInitializationDelayBase: TimeInterval

    /// The maximum time interval for scheduling a retry of the Core SDK initialization.
    /// See ``Math.retryDelayInterval(retryNumber:base:limit:)`` for more info.
    let coreInitializationDelayMax: TimeInterval

    /// The maximum number of times the Core SDK initialization will be retried automatically.
    let coreInitializationRetryCountMax: Int

    /// Log level setting that, if received from the backend, will override the local default.
    let logLevelOverride: LogLevel?

    /// The base value to use when scheduling a retry of a Core module initialization.
    /// See ``Math.retryDelayInterval(retryNumber:base:limit:)`` for more info.
    let moduleInitializationDelayBase: TimeInterval

    /// The maximum time interval for scheduling a retry of a Core module initialization.
    /// See ``Math.retryDelayInterval(retryNumber:base:limit:)`` for more info.
    let moduleInitializationDelayMax: TimeInterval

    /// The maximum number of times a Core module initialization will be retried automatically.
    let moduleInitializationRetryCountMax: Int

    /// List of module information defined on the backend to be used by the SDK on initialization.
    let modules: [ModuleInfo]
}
