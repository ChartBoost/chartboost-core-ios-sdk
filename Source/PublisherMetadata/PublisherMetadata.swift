// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Publisher-provided metadata.
@objc(CBCPublisherMetadata)
@objcMembers
public final class PublisherMetadata: NSObject {
    @Injected(\.environmentChangePublisher) private var environmentChangePublisher
    @Injected(\.publisherInfoProvider) private var publisherInfoProvider

    /// Sets the framework name and version for this app, e.g. ("Unity", "2022.3").
    public func setFramework(name: String?, version: String?) {
        publisherInfoProvider.frameworkName = name
        publisherInfoProvider.frameworkVersion = version
        environmentChangePublisher.publishChange(to: .frameworkName)
        environmentChangePublisher.publishChange(to: .frameworkVersion)
    }

    /// Indicates if the user is underage as determined by the publisher.
    public func setIsUserUnderage(_ value: Bool) {
        publisherInfoProvider.isUserUnderage = value
        environmentChangePublisher.publishChange(to: .isUserUnderage)
    }

    /// Sets a publisher-defined player ID.
    public func setPlayerID(_ value: String?) {
        publisherInfoProvider.playerID = value
        environmentChangePublisher.publishChange(to: .playerID)
    }

    /// Sets a publisher-defined application identifier.
    public func setPublisherAppID(_ value: String?) {
        publisherInfoProvider.publisherAppID = value
        environmentChangePublisher.publishChange(to: .publisherAppID)
    }

    /// Sets a publisher-defined session identifier.
    public func setPublisherSessionID(_ value: String?) {
        publisherInfoProvider.publisherSessionID = value
        environmentChangePublisher.publishChange(to: .publisherSessionID)
    }

    // Make NSObject init private to prevent users from instantiating this class.
    override internal init() {
        super.init()
    }
}
