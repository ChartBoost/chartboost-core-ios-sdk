// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// An observer to be notified whenever a Core module finishes initialization.
@objc(CBCModuleObserver)
public protocol ModuleObserver: AnyObject {
    /// Called whenever a module is initialized by the Chartboost Core SDK.
    ///
    /// Note that Chartboost Core may attempt to initialize the same module multiple times
    /// before this method is called. This method will only be invoked once the module
    /// has been successfully initialized or when the SDK has ceased its attempts at initialization.
    /// - parameter result: The result of the initialization.
    func onModuleInitializationCompleted(_ result: ModuleInitializationResult)
}
