// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

extension PublisherMetadata {

    /// A property that identifies a publisher metadata field that can be accessed through
    /// Chartboost Core's environment (e.g. ``ChartboostCore/analyticsEnvironment``) and modified through
    /// the ``ChartboostCore/publisherMetadata`` object.
    @objc(CBCPublisherMetadataProperty)
    public enum Property: Int, CustomStringConvertible {

        /// Property identifier associated to ``PublisherMetadata/setFrameworkName(_:)`` and ``AnalyticsEnvironment/frameworkName``.
        case frameworkName

        /// Property identifier associated to ``PublisherMetadata/setFrameworkVersion(_:)`` and ``AnalyticsEnvironment/frameworkVersion``.
        case frameworkVersion

        /// Property identifier associated to ``PublisherMetadata/setIsUserUnderage(_:)`` and ``AnalyticsEnvironment/isUserUnderage``.
        case isUserUnderage

        /// Property identifier associated to ``PublisherMetadata/setPlayerID(_:)`` and ``AnalyticsEnvironment/playerID``.
        case playerID

        /// Property identifier associated to ``PublisherMetadata/setPublisherAppID(_:)`` and ``AnalyticsEnvironment/publisherAppID``.
        case publisherAppID

        /// Property identifier associated to ``PublisherMetadata/setPublisherSessionID(_:)`` and ``AnalyticsEnvironment/frameworkName``.
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
}
