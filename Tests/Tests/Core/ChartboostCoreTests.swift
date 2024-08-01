// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class ChartboostCoreTests: ChartboostCoreTestCase {
    /// Validates that `initializeSDK()` calls are forwarded to the proper component.
    func testInitializeSDK() {
        let modules = [ModuleMock(), ModuleMock()]
        let configuration = SDKConfiguration(chartboostAppID: "", modules: modules)
        let observer = ModuleObserverMock()

        ChartboostCore.initializeSDK(configuration: configuration, moduleObserver: observer)

        XCTAssertEqual(mocks.sdkInitializer.initializeSDKCallCount, 1)
        XCTAssertEqual(mocks.sdkInitializer.initializeSDKConfigurationLastValue, configuration)
        XCTAssertIdentical(mocks.sdkInitializer.initializeSDKModulesLastValue?[0], modules[0])
        XCTAssertIdentical(mocks.sdkInitializer.initializeSDKModulesLastValue?[1], modules[1])
        XCTAssertIdentical(mocks.sdkInitializer.initializeSDKModuleObserverLastValue, observer)
    }

    /// Validates that `sdkVersion` is a semantic version string.
    func testSDKVersion() {
        XCTAssertFalse(ChartboostCore.sdkVersion.isEmpty)
        let components = ChartboostCore.sdkVersion.components(separatedBy: ".")
        guard components.count == 3 else {
            XCTFail("sdkVersion does not have 3 components")
            return
        }
        XCTAssertNotNil(Int(components[0]))
        XCTAssertNotNil(Int(components[1]))
        XCTAssertNotNil(Int(components[2]))
    }

    /// Validates that the public `logLevel` property is in sync with the console handler's property.
    func testLogLevel() {
        // Set the initial log level value
        ConsoleLogHandler.core.logLevel = .debug

        // Check that ChartboostCore's value corresponds to the initial value
        XCTAssertEqual(ChartboostCore.logLevel, .debug)

        // Modify the log level through the public setter
        ChartboostCore.logLevel = .info

        // Check that both public and internal properties reflect the new value
        XCTAssertEqual(ChartboostCore.logLevel, .info)
        XCTAssertEqual(ConsoleLogHandler.core.logLevel, .info)
    }

    /// Validates that `attachLogHandler(_:)` makes it so the new handler receives log entries.
    func testAttachHandler() {
        let handler = LogHandlerMock()

        // Attach the handler
        ChartboostCore.attachLogHandler(handler)

        // Log a message
        logger.error("some error message")
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that the handler received the expected log entry
        XCTAssertEqual(handler.handleCallCount, 1)
        XCTAssertEqual(handler.handleEntryLastValue?.message, "some error message")
        XCTAssertEqual(handler.handleEntryLastValue?.logLevel, .error)
    }

    /// Validates that `detachLogHandler(_:)` makes it so the handler stops receiving log entries.
    func testDetachHandler() {
        let handler = LogHandlerMock()

        // Attach and detach the handler
        ChartboostCore.attachLogHandler(handler)
        ChartboostCore.detachLogHandler(handler)

        // Log a message
        logger.error("some error message")
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that the handler received no calls
        XCTAssertEqual(handler.handleCallCount, 0)
    }

    /// Validates that the private `nonNativeModuleFactory` property is accessible through reflection.
    func testUnityModuleFactory() throws {
        // Access when not set
        XCTAssertNil(ChartboostCore.value(forKey: "nonNativeModuleFactory"))

        // Set new value
        let factory = ModuleFactoryMock()
        ChartboostCore.perform(NSSelectorFromString("setNonNativeModuleFactory:"), with: factory)

        // Check that the factory was set and that the getter returns the same value
        XCTAssertIdentical(mocks.moduleFactory.nonNativeModuleFactory, factory)
        XCTAssertIdentical(factory, ChartboostCore.value(forKey: "nonNativeModuleFactory") as? ModuleFactoryMock)
    }
}
