// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ChartboostCoreTests: ChartboostCoreTestCase {

    /// Validates that `initializeSDK()` calls are forwarded to the proper component.
    func testInitializeSDK() {
        let configuration = SDKConfiguration(chartboostAppID: "")
        let modules = [InitializableModuleMock(), InitializableModuleMock()]
        let observer = InitializableModuleObserverMock()

        ChartboostCore.initializeSDK(with: configuration, modules: modules, moduleObserver: observer)

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
}
