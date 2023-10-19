// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ChartboostCoreInitializableModuleFactoryTests: ChartboostCoreTestCase {

    let factory = ChartboostCoreInitializableModuleFactory()

    /// Validates that a call to `makeModule()` instantiates a valid module via reflection.
    func testMakeModuleWithValidInfo() {
        let credentials: [String : Any]? = ["some param": 23, "some param 2": "some value"]

        let module = factory.makeModule(className: "ChartboostCoreSDK_Unit_Tests.TestModule", credentials: credentials)

        XCTAssertNotNil(module)
        XCTAssertEqual(module?.moduleID, "test module")
        XCTAssertEqual((module as? TestModule)?.credentials?["some param"] as? Int, 23)
        XCTAssertEqual((module as? TestModule)?.credentials?["some param 2"] as? String, "some value")
    }

    /// Validates that a call to `makeModule()` returns nil if the info is not valid.
    func testMakeModuleWithInvalidInfo() {
        let module = factory.makeModule(className: "SomeUnexistentClassName", credentials: nil)

        XCTAssertNil(module)
    }
}

// Module class to test
public final class TestModule: InitializableModule {
    public var moduleID: String = "test module"

    public var moduleVersion: String = "1.0.0"

    let credentials: [String : Any]?

    public init(credentials: [String : Any]?) {
        self.credentials = credentials
    }

    public func initialize(
        configuration: ModuleInitializationConfiguration,
        completion: @escaping (Error?) -> Void
    ) {

    }
}
