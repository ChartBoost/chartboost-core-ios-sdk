// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A key in a Core consents dictionary.
public typealias ConsentKey = String

/// A namespace for Core's predefined ``ConsentKey`` constants.
@objc(CBCConsentKeys)
@objcMembers
public final class ConsentKeys: NSObject {
    /// CCPA opt-in key.
    /// Possible values are: ``ConsentValue/denied``, ``ConsentValue/granted``, ``ConsentValue/doesNotApply``.
    public static let ccpaOptIn: ConsentKey = "chartboost_core_ccpa_opt_in"

    /// GDPR consent given key.
    /// Possible values are: ``ConsentValue/denied``, ``ConsentValue/granted``, ``ConsentValue/doesNotApply``.
    public static let gdprConsentGiven: ConsentKey = "chartboost_core_gdpr_consent_given"

    /// GPP key.
    /// Possible values are IAB's GPP strings, as defined in https://github.com/InteractiveAdvertisingBureau/Global-Privacy-Platform/blob/main/Core/Consent%20String%20Specification.md
    public static let gpp: ConsentKey = "IABGPP_HDR_GppString"

    /// TCF key.
    /// Possible values are IAB's TCF strings, as defined in https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20Consent%20string%20and%20vendor%20list%20formats%20v2.md
    public static let tcf: ConsentKey = "IABTCF_TCString"

    /// USP key.
    /// Possible values are IAB's USP strings, as defined in https://github.com/InteractiveAdvertisingBureau/USPrivacy/blob/master/CCPA/US%20Privacy%20String.md
    public static let usp: ConsentKey = "IABUSPrivacy_String"

    @available(*, unavailable)
    override init() {
        fatalError("Instantiation is disallowed because this class is intended only to act as a namespace.")
    }
}
