// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class JSONURLResponseBodyParserTests: ChartboostCoreTestCase {

    /// Validates that a call to `parse()` returns a decoded model from the data object passed.
    func testParse() throws {
        let request = HTTPJSONRequestMock(acceptsJSONResponse: true)
        let responseBodyModel = HTTPJSONRequestMock.ResponseBody(field4: "some value", field5: 4444)
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = request.bodyKeyEncodingStrategy
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(responseBodyModel)

        let value = try JSONURLResponseBodyParser<HTTPJSONRequestMock>.parse(data, for: request)
        XCTAssertEqual(value, responseBodyModel)
    }
}
