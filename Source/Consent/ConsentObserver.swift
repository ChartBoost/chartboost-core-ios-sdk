// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// An observer that gets notified whenever any change happens in the CMP consent status.
@objc(CBCConsentObserver)
public protocol ConsentObserver: AnyObject {

    /// Called when the ``ConsentAdapter`` module is initialized and the ``ConsentManagementPlatform`` object
    /// is ready to be used.
    /// At this moment ``ConsentManagementPlatform/consentStatus`` and ``ConsentManagementPlatform/consents`` will
    /// have proper values and methods like ``ConsentManagementPlatform/showConsentDialog(_:from:)`` will no longer
    /// be no-ops.
    ///
    /// It's important to note that a consent adapter module may take some time to initialize and
    /// restore the consent information from a previous session. Until then, ``ConsentManagementPlatform``
    /// provides default values for its properties. Once the information becomes available,
    /// this method is invoked, and neither ``onConsentStatusChange(_:)`` nor ``onConsentChange(standard:value:)``
    /// are called.
    func onConsentModuleReady()

    /// Called whenever the ``ConsentManagementPlatform/consentStatus`` value changed.
    /// - parameter status: The new consent status.
    func onConsentStatusChange(_ status: ConsentStatus)

    /// Called whenever the ``ConsentAdapter/partnerConsentStatus`` value changed.
    /// - parameter partnerID: The ID of the partner SDK whose consent changed. Should match Chartboost Mediation partner adapter ids.
    /// - parameter status: The new consent status.
    func onPartnerConsentStatusChange(partnerID: String, status: ConsentStatus)

    /// Called whenever the ``ConsentManagementPlatform/consents`` value changed.
    /// - parameter standard: The standard that changed.
    /// - parameter value: The new value for the standard, `nil` if the entry was removed.
    func onConsentChange(standard: ConsentStandard, value: ConsentValue?)
}
