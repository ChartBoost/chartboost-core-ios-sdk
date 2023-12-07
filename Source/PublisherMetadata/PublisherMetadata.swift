// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Publisher-provided metadata.
@objc(CBCPublisherMetadata)
@objcMembers
public final class PublisherMetadata: NSObject {

    @Injected(\.publisherInfoProvider) private var publisherInfoProvider

    // List of observers added by the publisher.
    @Atomic private var observers: [WeakWrapper<PublisherMetadataObserver>] = []

    /// Sets the framework name for this app, e.g. "Unity".
    public func setFrameworkName(_ value: String?) {
        publisherInfoProvider.frameworkName = value
        forAllObservers { $0.onChange(.frameworkName) }
    }

    /// Sets the framework version for this app.
    public func setFrameworkVersion(_ value: String?) {
        publisherInfoProvider.frameworkVersion = value
        forAllObservers { $0.onChange(.frameworkVersion) }
    }

    /// Indicates if the user is underage as determined by the publisher.
    public func setIsUserUnderage(_ value: Bool) {
        publisherInfoProvider.isUserUnderage = value
        forAllObservers { $0.onChange(.isUserUnderage) }
    }

    /// Sets a publisher-defined player ID.
    public func setPlayerID(_ value: String?) {
        publisherInfoProvider.playerID = value
        forAllObservers { $0.onChange(.playerID) }
    }

    /// Sets a publisher-defined application identifier.
    public func setPublisherAppID(_ value: String?) {
        publisherInfoProvider.publisherAppID = value
        forAllObservers { $0.onChange(.publisherAppID) }
    }

    /// Sets a publisher-defined session identifier.
    public func setPublisherSessionID(_ value: String?) {
        publisherInfoProvider.publisherSessionID = value
        forAllObservers { $0.onChange(.publisherSessionID) }
    }

    public func addObserver(_ observer: PublisherMetadataObserver) {
        guard !observers.contains(where: { $0.value === observer }) else {
            logger.info("Publisher metadata observer not added: the object is already observing changes.")
            return
        }
        observers.append(WeakWrapper(observer))
    }

    public func removeObserver(_ observer: PublisherMetadataObserver) {
        observers.removeAll(where: { $0.value === observer })
    }

    // Make NSObject init private to prevent users from instantiating this class.
    override internal init() {
        super.init()
    }

    /// Iterates over all the observers in a thread-safe way, cleaning up references to any deallocated observers.
    private func forAllObservers(handler: @escaping (PublisherMetadataObserver) -> Void) {
        $observers.mutate { observers in
            // Remove wrappers for deallocated observers
            observers.removeAll(where: { $0.value == nil })
            // Forward callback to all observers
            observers.forEach { observer in
                DispatchQueue.main.async {  // on main thread in case the observer does some UI logic here
                    if let value = observer.value {
                        handler(value)
                    }
                }
            }
        }
    }
}
