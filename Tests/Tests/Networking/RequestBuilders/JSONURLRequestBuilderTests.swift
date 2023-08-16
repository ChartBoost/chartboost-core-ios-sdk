// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class JSONURLRequestBuilderTests: ChartboostCoreTestCase {

    /// Validates that a call to `makeURLRequest()` returns a URL request with proper values obtained
    /// from the request object passed, including an "accept" HTTP header.
    func testMakeURLRequestIfAcceptsJSONResponseIsTrue() throws {
        let request = HTTPJSONRequestMock(acceptsJSONResponse: true)
        let urlRequest = try JSONURLRequestBuilder<HTTPJSONRequestMock>.makeURLRequest(from: request)
        XCTAssertEqual(urlRequest.url, request.url)
        XCTAssertEqual(
            urlRequest.allHTTPHeaderFields,
            request.headers
                .merging(
                    ["Content-Type": "application/json; charset=utf-8",
                     "Accept": "application/json; charset=utf-8"],
                    uniquingKeysWith: { first, _ in first }
                )
        )
        XCTAssertEqual(urlRequest.httpMethod, request.method.description)

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = request.bodyKeyEncodingStrategy
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(request.body)
        XCTAssertEqual(urlRequest.httpBody, data)
    }

    /// Validates that a call to `makeURLRequest()` returns a URL request with proper values obtained
    /// from the request object passed, without an "accept" HTTP header.
    func testMakeURLRequestIfAcceptsJSONResponseIsFalse() throws {
        let request = HTTPJSONRequestMock(acceptsJSONResponse: false)
        let urlRequest = try JSONURLRequestBuilder<HTTPJSONRequestMock>.makeURLRequest(from: request)
        XCTAssertEqual(urlRequest.url, request.url)
        XCTAssertEqual(
            urlRequest.allHTTPHeaderFields,
            request.headers
                .merging(
                    ["Content-Type": "application/json; charset=utf-8"],
                    uniquingKeysWith: { first, _ in first }
                )
        )
        XCTAssertEqual(urlRequest.httpMethod, request.method.description)

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = request.bodyKeyEncodingStrategy
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(request.body)
        XCTAssertEqual(urlRequest.httpBody, data)
    }
}
