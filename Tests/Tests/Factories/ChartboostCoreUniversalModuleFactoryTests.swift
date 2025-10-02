// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class ChartboostCoreUniversalModuleFactoryTests: ChartboostCoreTestCase {
    lazy var factory = ChartboostCoreUniversalModuleFactory(nativeModuleFactory: nativeModuleFactory)
    let nativeModuleFactory = ModuleFactoryMock()
    let nonNativeModuleFactory = ModuleFactoryMock()

    /// Validates that a call to `makeModule()` with native module info returns the expected module instance.
    func testMakeNativeModule() throws {
        // Setup
        let moduleInfo = AppConfig.ModuleInfo(
            className: "SomeNativeClass",
            nonNativeClassName: nil,
            identifier: "some id",
            credentials: .init(value: ["credentials": 12])
        )
        let expectedModule = ModuleMock()
        nativeModuleFactory.makeModuleHandler = { _, _, completion in completion(expectedModule) }

        // Make module
        let expectation = self.expectation(description: "Module completion called")
        factory.makeModule(info: moduleInfo) { [self] module in
            // Check that the native module factory was used and returned the proper module instance
            XCTAssertIdentical(module, expectedModule)
            XCTAssertEqual(nativeModuleFactory.makeModuleCallCount, 1)
            XCTAssertEqual(nativeModuleFactory.makeModuleArguments.last?.className, moduleInfo.className)
            XCTAssertEqual(
                nativeModuleFactory.makeModuleArguments.last?.credentials as? [String: Int],
                moduleInfo.credentials?.value as? [String: Int]
            )
            XCTAssertEqual(nonNativeModuleFactory.makeModuleCallCount, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }

    /// Validates that a call to `makeModule()` with non-native module info returns the expected module instance.
    func testMakeNonNativeModule() throws {
        // Setup
        let moduleInfo = AppConfig.ModuleInfo(
            className: nil,
            nonNativeClassName: "SomeNonNativeClass",   // nonNativeClassName set instead of className
            identifier: "some id",
            credentials: .init(value: ["credentials": 12])
        )
        let expectedModule = ModuleMock()
        nonNativeModuleFactory.makeModuleHandler = { _, _, completion in completion(expectedModule) }

        // Set non-native factory and make module
        factory.nonNativeModuleFactory = nonNativeModuleFactory
        let expectation = self.expectation(description: "Module completion called")
        factory.makeModule(info: moduleInfo) { [self] module in
            // Check that the non-native module factory was used and returned the proper module instance
            XCTAssertIdentical(module, expectedModule)
            XCTAssertEqual(nonNativeModuleFactory.makeModuleCallCount, 1)
            XCTAssertEqual(nonNativeModuleFactory.makeModuleArguments.last?.className, moduleInfo.nonNativeClassName)
            XCTAssertEqual(
                nonNativeModuleFactory.makeModuleArguments.last?.credentials as? [String: Int],
                moduleInfo.credentials?.value as? [String: Int]
            )
            XCTAssertEqual(nativeModuleFactory.makeModuleCallCount, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }

    /// Validates that a call to `makeModule()` with non-native module info returns nil when no non-native factory is set.
    func testMakeNonNativeModuleWithNoNonNativeModuleFactory() throws {
        // Setup
        let moduleInfo = AppConfig.ModuleInfo(
            className: nil,
            nonNativeClassName: "SomeNonNativeClass",
            identifier: "some id",
            credentials: .init(value: ["credentials": 12])
        )

        // Make module WITHOUT setting the non-native factory
        let expectation = self.expectation(description: "Module completion called")
        factory.makeModule(info: moduleInfo) { [self] module in
            // Check that no factory was used and the returned module is nil
            XCTAssertNil(module)
            XCTAssertEqual(nonNativeModuleFactory.makeModuleCallCount, 0)
            XCTAssertEqual(nativeModuleFactory.makeModuleCallCount, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }

    /// Validates that a call to `makeModule()` with invalid module info returns nil.
    func testMakeInvalidModule() throws {
        // Setup
        let moduleInfo = AppConfig.ModuleInfo(
            className: nil, // both className and nonNativeClassName are nil
            nonNativeClassName: nil,
            identifier: "some id",
            credentials: .init(value: ["credentials": 12])
        )

        // Make module
        factory.nonNativeModuleFactory = nonNativeModuleFactory
        let expectation = self.expectation(description: "Module completion called")
        factory.makeModule(info: moduleInfo) { [self] module in
            // Check that no factory was used and the returned module is nil
            XCTAssertNil(module)
            XCTAssertEqual(nonNativeModuleFactory.makeModuleCallCount, 0)
            XCTAssertEqual(nativeModuleFactory.makeModuleCallCount, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }

    /// Validates that a call to `makeModule()` with native module info returns nil when the factory can't instantiate the module.
    func testMakeUnavailableNativeModule() throws {
        // Setup
        let moduleInfo = AppConfig.ModuleInfo(
            className: "SomeNativeClass",
            nonNativeClassName: nil,
            identifier: "some id",
            credentials: .init(value: ["credentials": 12])
        )
        // factory will return nil
        nativeModuleFactory.makeModuleHandler = { _, _, completion in completion(nil) }

        // Make module
        let expectation = self.expectation(description: "Module completion called")
        factory.makeModule(info: moduleInfo) { [self] module in
            // Check that the native module factory was used and the returned module is nil
            XCTAssertNil(module)
            XCTAssertEqual(nativeModuleFactory.makeModuleCallCount, 1)
            XCTAssertEqual(nativeModuleFactory.makeModuleArguments.last?.className, moduleInfo.className)
            XCTAssertEqual(
                nativeModuleFactory.makeModuleArguments.last?.credentials as? [String: Int],
                moduleInfo.credentials?.value as? [String: Int]
            )
            XCTAssertEqual(nonNativeModuleFactory.makeModuleCallCount, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }

    /// Validates that a call to `makeModule()` with non-native module info returns nil when the factory can't instantiate the module.
    func testMakeUnavailableNonNativeModule() throws {
        // Setup
        let moduleInfo = AppConfig.ModuleInfo(
            className: nil,
            nonNativeClassName: "SomeNonNativeClass",
            identifier: "some id",
            credentials: .init(value: ["credentials": 12])
        )
        // factory will return nil
        nonNativeModuleFactory.makeModuleHandler = { _, _, completion in completion(nil) }

        // Set non-native factory and make module
        factory.nonNativeModuleFactory = nonNativeModuleFactory
        let expectation = self.expectation(description: "Module completion called")
        factory.makeModule(info: moduleInfo) { [self] module in
            // Check that the non-native module factory was used and the returned module is nil
            XCTAssertNil(module)
            XCTAssertEqual(nonNativeModuleFactory.makeModuleCallCount, 1)
            XCTAssertEqual(nonNativeModuleFactory.makeModuleArguments.last?.className, moduleInfo.nonNativeClassName)
            XCTAssertEqual(
                nonNativeModuleFactory.makeModuleArguments.last?.credentials as? [String: Int],
                moduleInfo.credentials?.value as? [String: Int]
            )
            XCTAssertEqual(nativeModuleFactory.makeModuleCallCount, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
}
