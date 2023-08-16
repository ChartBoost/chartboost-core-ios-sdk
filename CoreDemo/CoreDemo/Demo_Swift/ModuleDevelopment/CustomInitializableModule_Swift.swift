// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import ChartboostCoreSDK

/// Code demo for how to create a custom module that conforms to the `InitializableModule` protocol.
@objc
@objcMembers
final class CustomInitializableModule_Swift: NSObject, InitializableModule {

    // Custom error for reporting initialization failures.
    enum InitError: Error {
        case customError
    }

    let moduleID = "custom_module_swift"
    let moduleVersion = "1.0.0"

    // Some custom values for this module.
    let customString: String?
    let customNumber: Int?

    // For holding the JSON obtained from backend configuration.
    private let credentials: [String: Any]?

    // The custom `init` for custom values when instantiated by the client side business logic.
    init(customString: String, customNumber: Int) {
        self.customString = customString
        self.customNumber = customNumber
        credentials = nil
    }

    // The `InitializableModule` required `init` when instantiated via reflection by the backend configuration.
    init(credentials: [String : Any]?) {
        customString = nil
        customNumber = nil
        self.credentials = credentials
    }

    // The `ChartboostCore` SDK calls this to initialize the module.
    func initialize(completion: @escaping (Error?) -> Void) {
        let errorHappend = Bool.random()

        if errorHappend {
            // Report an error if something went wrong.
            // The `ChartboostCore` SDK will retry a few times before reporting the error to
            // `InitializableModuleObserver` via the `onModuleInitializationCompleted()`
            // callback.
            // In this demo, initialization is very likely to be successful within a few retries.
            completion(InitError.customError)
        } else {
            // Report success to the `ChartboostCore` SDK.
            completion(nil)
        }
    }
}
