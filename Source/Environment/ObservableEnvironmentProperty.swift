// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A constant that identifies an environment property that can be observed via a ``EnvironmentObserver``.
@objc(CBCObservableEnvironmentProperty)
public enum ObservableEnvironmentProperty: Int, CustomStringConvertible {
    /// Property identifier associated to ``AnalyticsEnvironment/frameworkName``.
    case frameworkName

    /// Property identifier associated to ``AnalyticsEnvironment/frameworkVersion``.
    case frameworkVersion

    /// Property identifier associated to ``AnalyticsEnvironment/isUserUnderage``.
    case isUserUnderage

    /// Property identifier associated to ``AnalyticsEnvironment/playerID``.
    case playerID

    /// Property identifier associated to ``AnalyticsEnvironment/publisherAppID``.
    case publisherAppID

    /// Property identifier associated to ``AnalyticsEnvironment/frameworkName``.
    case publisherSessionID

    /// The string representation of the property.
    public var description: String {
        switch self {
        case .frameworkName: return "frameworkName"
        case .frameworkVersion: return "frameworkVersion"
        case .isUserUnderage: return "isUserUnderage"
        case .playerID: return "playerID"
        case .publisherAppID: return "publisherAppID"
        case .publisherSessionID: return "publisherSessionID"
        }
    }
}
