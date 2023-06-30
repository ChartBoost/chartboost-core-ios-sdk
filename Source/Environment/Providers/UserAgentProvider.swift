// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import WebKit

protocol UserAgentProvider {
    var userAgent: String? { get }
    func updateUserAgent()
}

/// Upon `init`, `UserAgentProvider` creates a `WKWebView` instance from main thread to obtain
/// the user agent value by evaluating JavaScript "navigator.userAgent".
final class ChartboostCoreUserAgentProvider: UserAgentProvider {

    /// Only for obtaining the user agent value.
    private var webView: WKWebView?

    private(set) var userAgent: String?

    func updateUserAgent() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let webView = WKWebView()
            self.webView = webView
            webView.evaluateJavaScript("navigator.userAgent") { [weak self] (result, error) in
                defer {
                    self?.webView = nil
                }

                guard error == nil, let result = result as? String else {
                    return
                }

                self?.userAgent = result
            }
        }
    }
}

