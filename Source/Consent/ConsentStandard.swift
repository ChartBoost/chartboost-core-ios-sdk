// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A model representing a user consent standard, like IAB's TCF or USP strings.
/// It is used by ``ConsentManagementPlatform`` to provide detailed consent status.
@objc(CBCConsentStandard)
@objcMembers
public final class ConsentStandard: NSObject, ExpressibleByStringLiteral {

    /// CCPA opt-in standard.
    /// Possible values are: ``ConsentValue.denied``, ``ConsentValue.granted``, ``ConsentValue.doesNotApply``.
    public static let ccpaOptIn: ConsentStandard = "ccpa_opt_in"

    /// GDPR consent given standard.
    /// Possible values are: ``ConsentValue.denied``, ``ConsentValue.granted``, ``ConsentValue.doesNotApply``.
    public static let gdprConsentGiven: ConsentStandard = "gdpr_consent_given"

    /// GPP standard.
    /// Possible values are IAB's GPP strings, as defined in https://github.com/InteractiveAdvertisingBureau/Global-Privacy-Platform/blob/main/Core/Consent%20String%20Specification.md
    public static let gpp: ConsentStandard = "gpp"

    /// TCF standard.
    /// Possible values are IAB's TCF strings, as defined in https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20Consent%20string%20and%20vendor%20list%20formats%20v2.md
    public static let tcf: ConsentStandard = "tcf"

    /// USP standard.
    /// Possible values are IAB's USP strings, as defined in https://github.com/InteractiveAdvertisingBureau/USPrivacy/blob/master/CCPA/US%20Privacy%20String.md
    public static let usp: ConsentStandard = "usp"

    /// The string value for this standard.
    public let value: String

    private override init() {
        fatalError()
    }

    /// Creates a custom standard with an arbitrary string value.
    public required init(stringLiteral value: StringLiteralType) {
        self.value = value
    }

    public override var description: String {
        value
    }

    // Compare the backing `value` instead of the object itself. Without this, custom `ConsentStandard`
    // declared as a `static var` always fails the equality test because a new instance is generated
    // each time.
    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else {
            return false
        }

        return value == other.value
    }

    public override var hash: Int {
        value.hash
    }
}

extension ConsentStandard: Codable {
    public convenience init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self.init(stringLiteral: value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

/// Obj-C NSDictionary keys must conform to NSCopying.
extension ConsentStandard: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        ConsentStandard(stringLiteral: value)
    }
}
