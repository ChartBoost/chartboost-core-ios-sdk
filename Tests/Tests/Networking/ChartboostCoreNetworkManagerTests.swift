// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ChartboostCoreNetworkManagerTests: ChartboostCoreTestCase {

    private static let urlSessionConfig: URLSessionConfiguration = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        URLProtocol.registerClass(URLProtocolMock.self)
        return config
    }()

    lazy var networkManager = ChartboostCoreNetworkManager(urlSessionConfig: Self.urlSessionConfig)

    override func setUp() {
        URLProtocolMock.reset()
    }

    /// Validates that a call to `send()` completes with success if the data task succeeds
    func testSendRequestWithSuccess() {
        let request = HTTPDataRequestMock()

        // Expected values
        let responseData = "some response".data(using: .utf8)
        let urlResponse = HTTPURLResponse(url: request.url, statusCode: 200, httpVersion: nil, headerFields: ["param": "value"])!

        // Send the request
        let expectation = self.expectation(description: "wait for http response")
        URLProtocolMock.dataTaskURLRequestHandler = { _ in
            (urlResponse, responseData, nil)
        }

        networkManager.send(request) { response in
            // Check the response has the expected values
            XCTAssertEqual(response.statusCode, urlResponse.statusCode)
            XCTAssertEqual(response.headers as? [String: String], urlResponse.allHeaderFields as? [String: String])
            XCTAssertEqual(try? response.result.get(), responseData)
            expectation.fulfill()
        }

        // The the send() completion should be executed at this point
        waitForExpectations(timeout: 5)

        // Check that the data task started
        XCTAssertEqual(URLProtocolMock.dataTaskCallCount, 1)
        XCTAssertEqual(URLProtocolMock.dataTaskURLRequestLastValue?.url, request.url)
        XCTAssertEqual(URLProtocolMock.dataTaskURLRequestLastValue?.httpMethod, request.method.description)
    }

    /// Validates that a call to `send()` completes with failure if the data task fails.
    func testSendRequestWithFailedDataTask() {
        let request = HTTPDataRequestMock()

        // Expected values
        let expectedError = NSError(domain: "networking error", code: 42)
        URLProtocolMock.dataTaskURLRequestHandler = { _ in
            (nil, nil, expectedError)
        }

        // Send the request
        let expectation = self.expectation(description: "wait for http response")
        networkManager.send(request) { response in
            // Check the response has the expected values
            XCTAssertNil(response.statusCode)
            XCTAssertNil(response.headers)
            switch response.result {
            case .success:
                XCTFail("Response should be a failure")
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, expectedError.domain)
                XCTAssertEqual((error as NSError).code, expectedError.code)
            }
            expectation.fulfill()
        }

        // The the send() completion should be executed at this point
        waitForExpectations(timeout: 5)

        // Check that the data task started
        XCTAssertEqual(URLProtocolMock.dataTaskCallCount, 1)
        XCTAssertEqual(URLProtocolMock.dataTaskURLRequestLastValue?.url, request.url)
        XCTAssertEqual(URLProtocolMock.dataTaskURLRequestLastValue?.httpMethod, request.method.description)
    }

    /// Validates that a call to `send()` completes with failure if response status code is a 500.
    func testSendRequestWith500Response() {
        let request = HTTPDataRequestMock()

        // Expected values
        let responseData = "some response".data(using: .utf8)
        let urlResponse = HTTPURLResponse(url: request.url, statusCode: 500, httpVersion: nil, headerFields: ["param": "value"])!

        // Send the request
        let expectation = self.expectation(description: "wait for http response")
        URLProtocolMock.dataTaskURLRequestHandler = { _ in
            (urlResponse, responseData, nil)
        }

        networkManager.send(request) { response in
            // Check the response has the expected values
            XCTAssertEqual(response.statusCode, urlResponse.statusCode)
            XCTAssertEqual(response.headers as? [String: String], urlResponse.allHeaderFields as? [String: String])
            switch response.result {
            case .success:
                XCTFail("Response should be a failure")
            case .failure(let error):
                XCTAssertEqual(error as? ChartboostCoreNetworkManager.NetworkError, ChartboostCoreNetworkManager.NetworkError.nonSuccessfulStatusCode(urlResponse.statusCode))
            }
            expectation.fulfill()
        }

        // The the send() completion should be executed at this point
        waitForExpectations(timeout: 5)

        // Check that the data task started
        XCTAssertEqual(URLProtocolMock.dataTaskCallCount, 1)
        XCTAssertEqual(URLProtocolMock.dataTaskURLRequestLastValue?.url, request.url)
        XCTAssertEqual(URLProtocolMock.dataTaskURLRequestLastValue?.httpMethod, request.method.description)
    }

    /// Validates that a call to `send()` completes with failure if the request is invalid.
    func testSendRequestWithInvalidRequest() {
        // Expected values
        let expectedError = NSError(domain: "make url request error", code: 42)
        let request = InvalidHTTPRequestMock(makeURLRequestError: expectedError, parseResponseBodyError: nil)

        // Send the request
        let expectation = self.expectation(description: "wait for http response")
        URLProtocolMock.dataTaskURLRequestHandler = { _ in
            (nil, nil, expectedError)
        }

        networkManager.send(request) { response in
            // Check the response has the expected values
            XCTAssertNil(response.statusCode)
            XCTAssertNil(response.headers)
            switch response.result {
            case .success:
                XCTFail("Response should be a failure")
            case .failure(let error):
                XCTAssertEqual(error as NSError, expectedError)
            }
            expectation.fulfill()
        }

        // The the send() completion should be executed at this point
        waitForExpectations(timeout: 5)

        // Check that no data task started
        XCTAssertEqual(URLProtocolMock.dataTaskCallCount, 0)
        XCTAssertNil(URLProtocolMock.dataTaskURLRequestLastValue)
    }

    /// Validates that a call to `send()` completes with failure if the response cannot be parsed.
    func testSendRequestWithInvalidResponse() {
        // Expected values
        let expectedError = NSError(domain: "parse response body error", code: 42)
        let request = InvalidHTTPRequestMock(makeURLRequestError: nil, parseResponseBodyError: expectedError)
        let responseData = "some response".data(using: .utf8)
        let urlResponse = HTTPURLResponse(url: request.url, statusCode: 200, httpVersion: nil, headerFields: ["param": "value"])!

        // Send the request
        let expectation = self.expectation(description: "wait for http response")
        URLProtocolMock.dataTaskURLRequestHandler = { _ in
            (urlResponse, responseData, nil)
        }

        networkManager.send(request) { response in
            // Check the response has the expected values
            XCTAssertEqual(response.statusCode, urlResponse.statusCode)
            XCTAssertEqual(response.headers as? [String: String], urlResponse.allHeaderFields as? [String: String])
            switch response.result {
            case .success:
                XCTFail("Response should be a failure")
            case .failure(let error):
                XCTAssertEqual(error as NSError, expectedError)
            }
            expectation.fulfill()
        }

        // The the send() completion should be executed at this point
        waitForExpectations(timeout: 5)

        // Check that the data task started
        XCTAssertEqual(URLProtocolMock.dataTaskCallCount, 1)
        XCTAssertEqual(URLProtocolMock.dataTaskURLRequestLastValue?.url, request.url)
        XCTAssertEqual(URLProtocolMock.dataTaskURLRequestLastValue?.httpMethod, request.method.description)

    }

    /// Validates that a call to `send()` completes with success if the response contains no data.
    func testSendRequestWithNoResponseData() {
        let request = HTTPDataRequestMock()

        // Expected values
        let urlResponse = HTTPURLResponse(url: request.url, statusCode: 204, httpVersion: nil, headerFields: ["param": "value"])!

        // Send the request
        let expectation = self.expectation(description: "wait for http response")
        URLProtocolMock.dataTaskURLRequestHandler = { _ in
            (urlResponse, nil, nil)
        }

        networkManager.send(request) { response in
            // Check the response has the expected values
            XCTAssertEqual(response.statusCode, urlResponse.statusCode)
            XCTAssertEqual(response.headers as? [String: String], urlResponse.allHeaderFields as? [String: String])
            switch response.result {
            case .success(let data):
                XCTAssert(data?.count == 0)
            case .failure:
                XCTFail("Response should have succeeded")
            }
            expectation.fulfill()
        }

        // The the send() completion should be executed at this point
        waitForExpectations(timeout: 5)

        // Check that the data task started
        XCTAssertEqual(URLProtocolMock.dataTaskCallCount, 1)
        XCTAssertEqual(URLProtocolMock.dataTaskURLRequestLastValue?.url, request.url)
        XCTAssertEqual(URLProtocolMock.dataTaskURLRequestLastValue?.httpMethod, request.method.description)
    }
}
