// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// An environment that contains information intended solely for attribution purposes.
/// - warning: Make sure to access UI-related properties from the main thread.
@objc(CBCAttributionEnvironment)
public protocol AttributionEnvironment {

    /// The system advertising identifier (IFA).
    var advertisingID: String? { get }

    /// Obtain the device user agent asynchronously.
    func userAgent(completion: @escaping (_ userAgent: String) -> Void)
}
