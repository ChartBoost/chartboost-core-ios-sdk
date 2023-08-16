// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import WebKit

/// Provides information related to the user agent.
protocol UserAgentProvider {

    /// The device user agent, or `nil` if one hasn't been fetched yet.
    var userAgent: String? { get }

    /// Tries to fetch a new value for the user agent.
    func updateUserAgent()
}

/// Core's concrete implementation of ``UserAgentProvider``.
///
/// Upon `init`, `UserAgentProvider` creates a `WKWebView` instance from main thread to obtain
/// the user agent value by evaluating JavaScript "navigator.userAgent".
final class ChartboostCoreUserAgentProvider: UserAgentProvider {

    /// Only for obtaining the user agent value.
    private var webView: WKWebView?

    /// The currently cached value for user agent.
    @Atomic private(set) var userAgent: String?

    func updateUserAgent() {
        logger.debug("Updating user agent...")

        // Dispatch on main queue since we are using UI-related APIs.
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            // Create a webview, execute a JS command to obtain the user agent.
            let webView = WKWebView()
            self.webView = webView
            webView.evaluateJavaScript("navigator.userAgent") { [weak self] (result, error) in
                defer {
                    self?.webView = nil
                }

                // Failure
                guard error == nil, let result = result as? String else {
                    logger.error("Failed to update user agent with error: \(String(describing: error)), result: '\(result ?? "nil")'")
                    return
                }

                // Success
                self?.userAgent = result
                logger.info("Updated user agent")
            }
        }
    }
}

