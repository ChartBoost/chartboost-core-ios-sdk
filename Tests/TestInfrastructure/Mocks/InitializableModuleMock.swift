// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

class InitializableModuleMock: InitializableModule {

    init(id: String = "mock module ID") {
        moduleID = id
        initCredentialsValue = nil
    }

    // MARK: - Call Counts and Return Values

    let initCredentialsValue: [String: Any]?
    var initializeCallCount = 0
    var initializeCompletionLastValue: ((Error?) -> Void)?

    // MARK: - InitializableModule

    var moduleID: String = "mock module ID"
    var moduleVersion: String = "1.2.3"

    required init(credentials: [String : Any]?) {
        initCredentialsValue = credentials
    }

    func initialize(
        completion: @escaping (Error?) -> Void
    ) {
        initializeCallCount += 1
        initializeCompletionLastValue = completion
    }
}
