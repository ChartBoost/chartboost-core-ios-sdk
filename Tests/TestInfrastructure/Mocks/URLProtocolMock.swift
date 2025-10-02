// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// This is for mocking `URLSession` data task handling. See this "Testing Tips & Tricks" WWDC
/// session for demo: https://developer.apple.com/videos/play/wwdc2018/417/
final class URLProtocolMock: URLProtocol {
    typealias URLRequestHandler = (URLRequest) throws -> (response: HTTPURLResponse?, data: Data?, error: Error?)

    static var dataTaskCallCount = 0
    static var dataTaskURLRequestLastValue: URLRequest?
    static var dataTaskURLRequestHandler: (URLRequestHandler)?

    static func reset() {
        dataTaskCallCount = 0
        dataTaskURLRequestLastValue = nil
        dataTaskURLRequestHandler = nil
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        Self.dataTaskCallCount += 1
        Self.dataTaskURLRequestLastValue = request

        guard let client else {
            fatalError("`client` is nil")
        }

        guard let handler = Self.dataTaskURLRequestHandler else {
            fatalError("`dataTaskURLRequestHandler` is nil")
        }

        do {
            let (response, data, error) = try handler(request)

            if let error {
                client.urlProtocol(self, didFailWithError: error)
                return
            }

            if let response {
                client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data {
                client.urlProtocol(self, didLoad: data)
            }
            client.urlProtocolDidFinishLoading(self)
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        // no-op
    }
}
