// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// The delegate of a ``ConsentAdapter`` module.
/// It should get notified whenever any change happens in the CMP consent status.
public protocol ConsentAdapterDelegate: AnyObject {

    /// Called whenever the ``ConsentAdapter/consentStatus`` value changed.
    /// - parameter status: The new consent status.
    func onConsentStatusChange(_ status: ConsentStatus)

    /// Called whenever the ``ConsentAdapter/partnerConsentStatus`` value changed.
    /// - parameter partnerID: The ID of the partner SDK whose consent changed. Should match Chartboost Mediation partner adapter ids.
    /// - parameter status: The new consent status.
    func onPartnerConsentStatusChange(partnerID: String, status: ConsentStatus)

    /// Called whenever the ``ConsentAdapter/consents`` value changed.
    /// - parameter standard: The standard that changed.
    /// - parameter value: The new value for the standard, `nil` if the entry was removed.
    func onConsentChange(standard: ConsentStandard, value: ConsentValue?)
}
