// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class ModuleInitializationResultTests: XCTestCase {
    /// Validates that init creates an object with the appropriate values.
    func testInit() {
        let module = ModuleMock()
        let startDate = Date(timeIntervalSinceNow: -30)
        let endDate = Date(timeIntervalSinceNow: 2.5)
        let error = NSError(domain: "", code: 2, userInfo: nil)

        let result = ModuleInitializationResult(startDate: startDate, endDate: endDate, error: error, module: module)

        XCTAssertEqual(result.moduleID, module.moduleID)
        XCTAssertEqual(result.moduleVersion, module.moduleVersion)
        XCTAssertEqual(result.startDate, startDate)
        XCTAssertEqual(result.endDate, endDate)
        XCTAssertIdentical(result.error as? NSError, error)
        XCTAssertEqual(result.duration, endDate.timeIntervalSince(startDate))
    }
}
