// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class ChartboostCoreModuleInitializerFactoryTests: ChartboostCoreTestCase {
    let factory = ChartboostCoreModuleInitializerFactory()

    /// Validates that a call to `makeModuleInitializer()` returns an initializer with proper values.
    func testMakeModuleInitializer() {
        let module = ModuleMock()

        let initializer = factory.makeModuleInitializer(module: module)

        XCTAssertEqual(initializer.module.moduleID, module.moduleID)
    }
}
