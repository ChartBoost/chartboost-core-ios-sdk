// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ConsentValueTests: XCTestCase {

    func testPredefinedValues() {
        XCTAssertEqual(ConsentValue.denied, "denied")
        XCTAssertEqual(ConsentValue.doesNotApply, "does_not_apply")
        XCTAssertEqual(ConsentValue.granted, "granted")
    }

    func testInitWithStringLiteral() {
        let value = ConsentValue(stringLiteral: "hello")
        XCTAssertEqual(value.value, "hello")

        let value2: ConsentValue = "hello"
        XCTAssertEqual(value2.value, "hello")
    }

    func testDescription() {
        let value = ConsentValue(stringLiteral: "some value")
        XCTAssertEqual(value.description, "some value")
    }

    func testEquality() {
        let value1 = ConsentValue(stringLiteral: "some value")
        let value2 = ConsentValue(stringLiteral: "some value")

        XCTAssertEqual(value1, value2)
    }

    func testCodable() throws {
        let value = ConsentValue(stringLiteral: "some value")

        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        let decoder = JSONDecoder()
        let decodedValue = try decoder.decode(ConsentValue.self, from: data)

        XCTAssertEqual(value, decodedValue)
    }
}
