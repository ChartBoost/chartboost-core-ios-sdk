// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import WebKit

typealias UserAgentCompletion = (_ userAgent: String?) -> Void

/// Provides information related to the user agent.
protocol UserAgentProvider {

    /// Obtain the user agent asynchronously.
    /// - parameter completion: Handler executed at the end of the user agent fetch operation.
    /// It returns either a valid string value or `nil` if the fetch fails.
    /// If a valid value is already cached, the completion executes immediately.
    func userAgent(completion: @escaping UserAgentCompletion)
}

/// Core's concrete implementation of ``UserAgentProvider``.
///
/// Upon `init`, `UserAgentProvider` creates a `WKWebView` instance from main thread to obtain
/// the user agent value by evaluating JavaScript "navigator.userAgent".
final class ChartboostCoreUserAgentProvider: UserAgentProvider {

    /// Only for obtaining the user agent value.
    private var webView: WKWebView?

    /// The currently cached value for user agent.
    private var userAgent: String?

    /// For preventing repetitive expensive fetch.
    private var isFetchingUserAgent = false

    /// An array of completion handlers that are called as soon as obtaining the user agent.
    private var completionHandlers: [UserAgentCompletion] = []

    func userAgent(completion: @escaping UserAgentCompletion) {
        logger.debug("Updating user agent...")

        // Dispatch on main queue since we are using UI-related APIs.
        DispatchQueue.main.async { [self] in
            
            // If the user agent is already available, return immediately.
            if let userAgent = self.userAgent {
                logger.debug("Obtained user agent: \(userAgent)")
                completion(userAgent)
                return
            }

            self.completionHandlers.append(completion)

            // If fetch is already in progress, return immediately.
            if self.isFetchingUserAgent {
                return
            }

            // Create a webview, execute a JS command to obtain the user agent. This is an expensive operation.
            let webView = WKWebView()
            self.webView = webView
            self.isFetchingUserAgent = true

            webView.evaluateJavaScript("navigator.userAgent") { [weak self] (result, error) in

                // iOS calls this completion on main thread already, thus no need to use `DispatchQueue.main` here.

                guard let self else { 
                    completion(nil)
                    return
                }

                defer {
                    self.completionHandlers.forEach { completion in
                        completion(self.userAgent)
                    }
                    self.completionHandlers.removeAll()
                    self.webView = nil
                    self.isFetchingUserAgent = false
                }

                // Failure
                guard error == nil, let result = result as? String else {
                    logger.error("Failed to update user agent with error: \(String(describing: error)), result: '\(result ?? "nil")'")
                    return
                }

                // Success
                self.userAgent = result
                logger.info("Updated user agent: \(result)")
            }
        }
    }
}
