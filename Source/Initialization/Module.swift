// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// The protocol to which all Chartboost Core modules must conform to.
@objc(CBCModule)
public protocol Module: AnyObject {
    /// The module identifier.
    var moduleID: String { get }

    /// The version of the module.
    var moduleVersion: String { get }

    /// The designated initializer for the module.
    /// The Chartboost Core SDK will invoke this initializer when instantiating modules defined on
    /// the dashboard through reflection.
    /// - parameter credentials: A dictionary containing all the information required to initialize
    /// this module, as defined on the Chartboost Core's dashboard.
    ///
    /// - note: Modules should not perform costly operations on this initializer.
    /// Chartboost Core SDK may instantiate and discard several instances of the same module.
    /// Chartboost Core SDK keeps strong references to modules that are successfully initialized.
    init(credentials: [String: Any]?)

    /// Sets up the module to make it ready to be used.
    /// - parameter configuration: A ``ModuleConfiguration`` for configuring the module.
    /// - parameter completion: A completion handler to be executed when the module is done initializing.
    /// An error should be passed if the initialization failed, whereas `nil` should be passed if it succeeded.
    @objc(initializeWithConfiguration:completion:)
    func initialize(
        configuration: ModuleConfiguration,
        completion: @escaping (Error?) -> Void
    )
}
