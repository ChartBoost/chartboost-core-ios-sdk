// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

class ModuleMock: Module {
    init(moduleID: String = "mock module ID") {
        self.moduleID = moduleID
        initCredentialsValue = nil
    }

    // MARK: - Call Counts and Return Values

    let initCredentialsValue: [String: Any]?
    var initializeCallCount = 0
    var initializeCompletionLastValue: ((Error?) -> Void)?

    // MARK: - Module

    var moduleID: String = "mock module ID"
    var moduleVersion: String = "1.2.3"

    required init(credentials: [String: Any]?) {
        initCredentialsValue = credentials
    }

    func initialize(
        configuration: ModuleConfiguration,
        completion: @escaping (Error?) -> Void
    ) {
        initializeCallCount += 1
        initializeCompletionLastValue = completion
    }
}
