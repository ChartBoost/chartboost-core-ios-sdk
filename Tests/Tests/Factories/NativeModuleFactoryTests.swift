// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class NativeModuleFactoryTests: ChartboostCoreTestCase {
    let factory = NativeModuleFactory()

    /// Validates that a call to `makeModule()` instantiates a valid module via reflection.
    func testMakeModuleWithValidInfo() {
        let credentials: [String: Any]? = ["some param": 23, "some param 2": "some value"]

        let expectation = self.expectation(description: "Module completion called")
        factory.makeModule(className: "ChartboostCoreSDK_Unit_Tests.TestModule", credentials: credentials) { module in
            XCTAssertNotNil(module)
            XCTAssertEqual(module?.moduleID, "test module")
            XCTAssertEqual((module as? TestModule)?.credentials?["some param"] as? Int, 23)
            XCTAssertEqual((module as? TestModule)?.credentials?["some param 2"] as? String, "some value")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }

    /// Validates that a call to `makeModule()` returns nil if the info is not valid.
    func testMakeModuleWithInvalidInfo() {
        let expectation = self.expectation(description: "Module completion called")
        factory.makeModule(className: "SomeUnexistentClassName", credentials: nil) { module in
            XCTAssertNil(module)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
}

// Module class to test
public final class TestModule: Module {
    public var moduleID: String = "test module"

    public var moduleVersion: String = "1.0.0"

    let credentials: [String: Any]?

    public init(credentials: [String: Any]?) {
        self.credentials = credentials
    }

    public func initialize(
        configuration: ModuleConfiguration,
        completion: @escaping (Error?) -> Void
    ) {
    }
}
