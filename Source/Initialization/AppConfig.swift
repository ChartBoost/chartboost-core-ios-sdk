// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Internal representation of the app config defined on the backend.
struct AppConfig: Codable, Equatable {

    /// Backend-defined module information to be used on initialization.
    struct ModuleInfo: Codable, Equatable {

        /// The module class name, used to instantiate the module via reflection.
        let className: String

        /// The module identifier.
        let identifier: String

        /// The dictionary to pass to the module on init when instantiated via reflection.
        let credentials: JSON<[String: Any]>?
    }

    /// The base value to use when scheduling a retry of the Core SDK initialization.
    /// See ``Math.retryDelayInterval(retryNumber:base:limit:)`` for more info.
    var coreInitializationDelayBase: TimeInterval

    /// The maximum time interval for scheduling a retry of the Core SDK initialization.
    /// See ``Math.retryDelayInterval(retryNumber:base:limit:)`` for more info.
    var maxCoreInitializationDelay: TimeInterval

    /// The maximum number of times the Core SDK initialization will be retried automatically.
    var maxCoreInitializationRetryCount: Int

    /// The maximum time interval for scheduling a retry of a Core module initialization.
    /// See ``Math.retryDelayInterval(retryNumber:base:limit:)`` for more info.
    let maxModuleInitializationDelay: TimeInterval

    /// The maximum number of times a Core module initialization will be retried automatically.
    let maxModuleInitializationRetryCount: Int

    /// The base value to use when scheduling a retry of a Core module initialization.
    /// See ``Math.retryDelayInterval(retryNumber:base:limit:)`` for more info.
    let moduleInitializationDelayBase: TimeInterval

    /// Indicates if the app is marked as child-directed on the backend.
    let isChildDirected: Bool?

    /// List of module information defined on the backend to be used by the SDK on initialization.
    let modules: [ModuleInfo]
}
