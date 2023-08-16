// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Manages HTTP requests and responses, acting as a wrapper over URLSession.
protocol NetworkManager {

    /// Sends an HTTP request.
    /// - parameter request: The request to send.
    /// - parameter completion: The completion handler to be executed when the network operation is done.
    /// A `HTTPResponse` is passed containing a decoded response matching the expected type as defined by
    /// the request type.
    func send<Request: HTTPRequest>(
        _ request: Request,
        completion: @escaping (HTTPResponse<Request.ResponseBody>) -> Void
    )
}

/// Core's concrete implementation of ``NetworkManager``.
final class ChartboostCoreNetworkManager: NSObject, NetworkManager, URLSessionDelegate {

    enum NetworkError: Error, CustomStringConvertible, Equatable {
        case notHTTPURLResponse
        case nonSuccessfulStatusCode(Int)

        var description: String {
            switch self {
            case .notHTTPURLResponse:
                return "Response is not an `HTTPURLResponse`"
            case .nonSuccessfulStatusCode(let statusCode):
                return "Status code \(statusCode)"
            }
        }
    }

    private static var defaultURLSessionConfig: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        return config
    }()

    private let urlSessionConfig: URLSessionConfiguration

    private lazy var urlSession: URLSession = {
        let queue = OperationQueue()
        queue.name = "com.chartboost.core.url_session_delegate_queue"
        return URLSession(configuration: urlSessionConfig, delegate: self, delegateQueue: queue)
    }()

    init(urlSessionConfig: URLSessionConfiguration = ChartboostCoreNetworkManager.defaultURLSessionConfig) {
        self.urlSessionConfig = urlSessionConfig
        super.init()
    }
}

// MARK: - NetworkManager

extension ChartboostCoreNetworkManager {

    func send<Request: HTTPRequest>(
        _ request: Request,
        completion: @escaping (HTTPResponse<Request.ResponseBody>) -> Void
    ) {
        // Generate the URL request
        let urlRequest: URLRequest
        do {
            urlRequest = try Request.RequestBuilder.makeURLRequest(from: request)
        } catch {
            logger.error("Failed to create URL request with error: \(error)")
            completion(HTTPResponse(statusCode: nil, headers: nil, result: .failure(error)))
            return
        }

        // Create the data task
        let dataTask = self.urlSession.dataTask(with: urlRequest) { data, urlResponse, error in
            // Fail if we get an error
            if let error {
                logger.error("\(request) failed with error: \(error)")
                completion(HTTPResponse(statusCode: nil, headers: nil, result: .failure(error)))
                return
            }

            // Fail if the response has the wrong type (should never happen)
            // Apple doc: "Whenever you make an HTTP request, the URLResponse object you
            // get back is actually an instance of the HTTPURLResponse class."
            // See https://developer.apple.com/documentation/foundation/urlresponse
            guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
                let error = NetworkError.notHTTPURLResponse
                logger.error("\(request) failed with error: \(error)")
                completion(HTTPResponse(statusCode: nil, headers: nil, result: .failure(error)))
                return
            }

            // Fail if status code is not between 200 and 400
            let statusCode = httpURLResponse.statusCode
            guard 200..<400 ~= statusCode else {
                let error = NetworkError.nonSuccessfulStatusCode(statusCode)
                logger.error("\(request) failed with error: \(error)")
                completion(HTTPResponse(statusCode: statusCode, headers: httpURLResponse.allHeaderFields, result: .failure(error)))
                return
            }

            // Parse response data
            let responseBodyResult = Result<Request.ResponseBody?, Error> {
                if let data {
                    return try Request.ResponseBodyParser.parse(data, for: request)
                } else {
                    return nil
                }
            }
            switch responseBodyResult {
            case .success:
                logger.debug("\(request) succeeded")
            case .failure(let error):
                logger.debug("\(request) failed to parse response data with error: \(error)")
            }

            // Complete with success or failure depending on the data parsing result
            completion(HTTPResponse(
                statusCode: statusCode,
                headers: httpURLResponse.allHeaderFields,
                result: responseBodyResult
            ))
        }

        // Send the data task
        dataTask.resume()
    }
}

// MARK: - URLSessionTaskDelegate

extension ChartboostCoreNetworkManager: URLSessionTaskDelegate {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        let credential: URLCredential?
        let disposition: URLSession.AuthChallengeDisposition

        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust,
               serverTrust.evaluateForHost(challenge.protectionSpace.host) {
                credential = URLCredential(trust: serverTrust)
                disposition = credential != nil ? .useCredential : .performDefaultHandling
            } else {
                credential = nil
                disposition = .cancelAuthenticationChallenge
            }
        } else {
            credential = nil
            disposition = .performDefaultHandling
        }

        completionHandler(disposition, credential)
    }
}
