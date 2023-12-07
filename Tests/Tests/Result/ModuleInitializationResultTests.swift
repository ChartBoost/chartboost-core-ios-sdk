// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ModuleInitializationResultTests: XCTestCase {

    /// Validates that init creates an object with the appropriate values.
    func testInit() {
        let module = InitializableModuleMock()
        let startDate = Date(timeIntervalSinceNow: -30)
        let endDate = Date(timeIntervalSinceNow: 2.5)
        let error = NSError(domain: "", code: 2, userInfo: nil)

        let result = ModuleInitializationResult(startDate: startDate, endDate: endDate, error: error, module: module)

        XCTAssertIdentical(result.module, module)
        XCTAssertEqual(result.startDate, startDate)
        XCTAssertEqual(result.endDate, endDate)
        XCTAssertIdentical(result.error as? NSError, error)
        XCTAssertEqual(result.duration, endDate.timeIntervalSince(startDate))
    }
}
