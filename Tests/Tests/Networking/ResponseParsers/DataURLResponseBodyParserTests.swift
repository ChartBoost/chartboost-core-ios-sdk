// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class DataURLResponseBodyParserTests: ChartboostCoreTestCase {
    /// Validates that a call to `parse()` returns the same Data as the one passed.
    func testParse() throws {
        let request = HTTPDataRequestMock()
        let data = Data()
        let value = try DataURLResponseBodyParser<HTTPDataRequestMock>.parse(data, for: request)
        XCTAssertEqual(data, value)
    }
}
