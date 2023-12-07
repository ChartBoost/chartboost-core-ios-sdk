// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ChartboostCoreModuleInitializerFactoryTests: ChartboostCoreTestCase {

    let factory = ChartboostCoreModuleInitializerFactory()

    /// Validates that a call to `makeModuleInitializer()` returns an initializer with proper values.
    func testMakeModuleInitializer() {
        let module = InitializableModuleMock()

        let initializer = factory.makeModuleInitializer(module: module)

        XCTAssertEqual(initializer.module.moduleID, module.moduleID)
    }
}
