// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ConsentStandardTests: XCTestCase {

    func testPredefinedValues() {
        XCTAssertEqual(ConsentStandard.ccpaOptIn, "ccpa_opt_in")
        XCTAssertEqual(ConsentStandard.gdprConsentGiven, "gdpr_consent_given")
        XCTAssertEqual(ConsentStandard.gpp, "gpp")
        XCTAssertEqual(ConsentStandard.tcf, "tcf")
        XCTAssertEqual(ConsentStandard.usp, "usp")
    }

    func testInitWithStringLiteral() {
        let standard = ConsentStandard(stringLiteral: "hello")
        XCTAssertEqual(standard.value, "hello")

        let standard2: ConsentStandard = "hello"
        XCTAssertEqual(standard2.value, "hello")
    }

    func testDescription() {
        let standard = ConsentStandard(stringLiteral: "some value")
        XCTAssertEqual(standard.description, "some value")
    }

    func testEquality() {
        let standard1 = ConsentStandard(stringLiteral: "some value")
        let standard2 = ConsentStandard(stringLiteral: "some value")

        XCTAssertEqual(standard1, standard2)
    }

    func testCodable() throws {
        let standard = ConsentStandard(stringLiteral: "some value")

        let encoder = JSONEncoder()
        let data = try encoder.encode(standard)
        let decoder = JSONDecoder()
        let decodedStandard = try decoder.decode(ConsentStandard.self, from: data)

        XCTAssertEqual(standard, decodedStandard)
    }
}
