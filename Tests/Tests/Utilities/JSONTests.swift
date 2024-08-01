// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class JSONTests: ChartboostCoreTestCase {
    /// Validates that a JSON can be created with different value types.
    func testInit() {
        XCTAssertEqual(JSON(value: 1).value, 1)
        XCTAssertEqual(JSON(value: "string").value, "string")
        XCTAssertEqual(JSON(value: ["k1": "v1", "k2": "v2"]).value, ["k1": "v1", "k2": "v2"])
        XCTAssertEqual(JSON(value: [1, 2, 3]).value, [1, 2, 3])
        XCTAssertEqual(JSON(value: ["1", "2", "3"]).value, ["1", "2", "3"])
        XCTAssertEqual(JSON(value: true).value, true)
        XCTAssertEqual(JSON(value: 42.4242).value, 42.4242)

        let value: [String: Any] = ["key": "value", "key2": 23, "k3": [1, 2, 3], "k4": ["a": "b"]]
        let jsonValue = JSON(value: value)
        XCTAssertEqual(jsonValue.value["key"] as? String, "value")
        XCTAssertEqual(jsonValue.value["key2"] as? Int, 23)
        XCTAssertEqual(jsonValue.value["k3"] as? [Int], [1, 2, 3])
        XCTAssertEqual(jsonValue.value["k4"] as? [String: String], ["a": "b"])
    }

    /// Validates that two JSONs are equal if they hold the same values.
    func testEquatable() {
        XCTAssertEqual(JSON(value: 1), JSON(value: 1))
        XCTAssertEqual(JSON(value: "string"), JSON(value: "string"))
        XCTAssertEqual(JSON(value: ["k1": "v1", "k2": "v2"]), JSON(value: ["k1": "v1", "k2": "v2"]))
        XCTAssertEqual(JSON(value: [1, 2, 3]), JSON(value: [1, 2, 3]))
        XCTAssertEqual(JSON(value: ["1", "2", "3"]), JSON(value: ["1", "2", "3"]))
        XCTAssertEqual(JSON(value: true), JSON(value: true))
        XCTAssertEqual(JSON(value: 42.4242), JSON(value: 42.4242))

        XCTAssertNotEqual(JSON(value: 1), JSON(value: 2))
        XCTAssertNotEqual(JSON(value: "string"), JSON(value: "another value"))
        XCTAssertNotEqual(JSON(value: ["k1": "v1", "k2": "v2"]), JSON(value: ["k1": "v1", "k2": "v3"]))
    }

    /// Validates that at JSON object can be encoded and decoded.
    func testCodable() throws {
        try validateEncoding(of: JSON(value: 1))
        try validateEncoding(of: JSON(value: "string"))
        try validateEncoding(of: JSON(value: ["k1": "v1", "k2": "v2"]))
        try validateEncoding(of: JSON(value: [1, 2, 3]))
        try validateEncoding(of: JSON(value: ["1", "2", "3"]))
        try validateEncoding(of: JSON(value: true))
        try validateEncoding(of: JSON(value: 42.4242))
        try validateEncoding(of: JSON(value: ["key": "value", "key2": 23, "k3": [1, 2, 3], "k4": ["a": "b"]] as [String: Any]))

        func validateEncoding<T>(of value: JSON<T>) throws {
            let encoder = JSONEncoder()
            let data = try encoder.encode(value)
            let decoder = JSONDecoder()
            let decodedValue = try decoder.decode(JSON<T>.self, from: data)
            XCTAssertEqual(decodedValue, value)
        }
    }
}
