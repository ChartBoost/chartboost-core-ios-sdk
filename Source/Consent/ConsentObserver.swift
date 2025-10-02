// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// An observer that gets notified whenever any change happens in the CMP consent info.
@objc(CBCConsentObserver)
public protocol ConsentObserver: AnyObject {
    /// Called when the ``ConsentAdapter`` module is initialized and the ``ConsentManagementPlatform`` object
    /// is ready to be used.
    /// At this moment ``ConsentManagementPlatform/consents`` will have proper values and methods like
    /// ``ConsentManagementPlatform/showConsentDialog(_:from:)`` will no longer be no-ops.
    ///
    /// It's important to note that a consent adapter module may take some time to initialize and
    /// restore the consent information from a previous session. Until then, ``ConsentManagementPlatform``
    /// provides default values for its properties. Once the information becomes first available,
    /// this method is invoked, but not ``ConsentObserver/onConsentChange(fullConsents:modifiedKeys:)``.
    ///
    /// - parameter initialConsents: The initial value for ``ConsentManagementPlatform/consents`` right after the
    /// CMP became ready. Here the CMP may have restored consent info from a previous session.
    func onConsentModuleReady(initialConsents: [ConsentKey: ConsentValue])

    /// Called whenever the ``ConsentManagementPlatform/consents`` value changed.
    /// - parameter fullConsents: The new value for ``ConsentManagementPlatform/consents`` after the update,
    /// including both modified and unmodified consents.
    /// - parameter modifiedKeys: A set containing all the keys that changed.
    func onConsentChange(fullConsents: [ConsentKey: ConsentValue], modifiedKeys: Set<ConsentKey>)
}
