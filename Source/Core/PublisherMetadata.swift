// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Publisher-provided metadata.
@objc(CBCPublisherMetadata)
@objcMembers
public final class PublisherMetadata: NSObject {

    @Injected(\.publisherInfoProvider) private var publisherInfoProvider

    /// Sets the framework name for this app, e.g. "Unity".
    public func setFrameworkName(_ value: String?) {
        publisherInfoProvider.frameworkName = value
    }

    /// Sets the framework version for this app.
    public func setFrameworkVersion(_ value: String?) {
        publisherInfoProvider.frameworkVersion = value
    }

    /// Indicates if the user is underage as determined by the publisher.
    public func setIsUserUnderage(_ value: Bool) {
        publisherInfoProvider.isUserUnderage = value
    }

    /// Sets a publisher-defined player ID.
    public func setPlayerID(_ value: String?) {
        publisherInfoProvider.playerID = value
    }

    /// Sets a publisher-defined application identifier.
    public func setPublisherAppID(_ value: String?) {
        publisherInfoProvider.publisherAppID = value
    }

    /// Sets a publisher-defined session identifier.
    public func setPublisherSessionID(_ value: String?) {
        publisherInfoProvider.publisherSessionID = value
    }

    // Make NSObject init private to prevent users from instantiating this class.
    override internal init() {
        super.init()
    }
}
