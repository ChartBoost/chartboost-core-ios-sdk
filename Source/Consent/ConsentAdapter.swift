// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import UIKit

/// The protocol to which a CMP adapter module must conform to.
///
/// Core SDK identifies a CMP adapter from the list of modules it initializes based on conformance to this protocol.
/// When the publisher uses Core's CMP APIs (the ``ChartboostCore/consent``) method calls are forwarded to a Core module
/// that conforms to ``ConsentAdapter``, and such a module is also expected to report consent info changes back to the
/// Core SDK via its ``delegate`` property.
@objc(CBCConsentAdapter)
public protocol ConsentAdapter: Module {
    /// Indicates whether the CMP has determined that consent should be collected from the user.
    var shouldCollectConsent: Bool { get }

    /// Current user consent info as determined by the CMP.
    ///
    /// Consent info may include IAB strings, like TCF or GPP, and parsed boolean-like signals like "CCPA Opt In Sale"
    /// and partner-specific signals.
    ///
    /// Predefined consent key constants, such as ``ConsentKeys/tcf`` and ``ConsentKeys/usp``, are provided
    /// by Core. Adapters should use them when reporting the status of a common standard.
    /// Custom keys should only be used by adapters when a corresponding constant is not provided by the Core.
    ///
    /// Predefined consent value constants are also proivded, but are only applicable to non-IAB string keys, like
    /// ``ConsentKeys/ccpaOptIn`` and ``ConsentKeys/gdprConsentGiven``.
    var consents: [ConsentKey: ConsentValue] { get }

    /// The delegate to be notified whenever any change happens in the CMP consent info.
    /// This delegate is set by Core SDK and is an essential communication channel between Core and the CMP.
    /// Adapters should not set it themselves.
    var delegate: ConsentAdapterDelegate? { get set }

    /// Instructs the CMP to present a consent dialog to the user for the purpose of collecting consent.
    /// - parameter type: The type of consent dialog to present. See the ``ConsentDialogType`` documentation for more info.
    /// If the CMP does not support a given type, it should default to whatever type it does support.
    /// - parameter viewController: The view controller to present the consent dialog from.
    /// - parameter completion: This handler is called to indicate whether the consent dialog was successfully presented or not.
    /// Note that this is called at the moment the dialog is presented, **not when it is dismissed**.
    func showConsentDialog(
        _ type: ConsentDialogType,
        from viewController: UIViewController,
        completion: @escaping (_ succeeded: Bool) -> Void
    )

    /// Informs the CMP that the user has granted consent.
    /// This method should be used only when a custom consent dialog is presented to the user, thereby making the publisher
    /// responsible for the UI-side of collecting consent. In most cases ``showConsentDialog(_:from:completion:)`` should
    /// be used instead.
    /// If the CMP does not support custom consent dialogs or the operation fails for any other reason, the completion
    /// handler is executed with a `false` parameter.
    /// - parameter source: The source of the new consent. See the ``ConsentSource`` documentation for more info.
    /// - parameter completion: Handler called to indicate if the operation went through successfully or not.
    func grantConsent(source: ConsentSource, completion: @escaping (_ succeeded: Bool) -> Void)

    /// Informs the CMP that the user has denied consent.
    /// This method should be used only when a custom consent dialog is presented to the user, thereby making the publisher
    /// responsible for the UI-side of collecting consent. In most cases ``showConsentDialog(_:from:completion:)`` should
    /// be used instead.
    /// If the CMP does not support custom consent dialogs or the operation fails for any other reason, the completion
    /// handler is executed with a `false` parameter.
    /// - parameter source: The source of the new consent. See the ``ConsentSource`` documentation for more info.
    /// - parameter completion: Handler called to indicate if the operation went through successfully or not.
    func denyConsent(source: ConsentSource, completion: @escaping (_ succeeded: Bool) -> Void)

    /// Informs the CMP that the given consent should be reset.
    /// If the CMP does not support the `reset()` function or the operation fails for any other reason, the completion
    /// handler is executed with a `false` parameter.
    /// - parameter completion: Handler called to indicate if the operation went through successfully or not.
    func resetConsent(completion: @escaping (_ succeeded: Bool) -> Void)
}

// Extension to provide convenience logging methods.
extension ConsentAdapter {
    /// Logs a message using the Core SDK's internal logging system.
    /// - parameter message: The string to log.
    /// A prefix is added to identify the adapter when printing out the message to the console.
    /// - parameter level: The log severity level.
    public func log(_ message: String, level: LogLevel) {
        Logger(id: "adapter", name: "\(moduleID) adapter", parent: Logger.core)
            .log(message, level: level)
    }
}

// Extension to provide convenience IAB string methods.
extension ConsentAdapter {
    /// Obtains the IAB consent strings currently stored in UserDefaults.
    /// If the CMP follows the IAB standard this can be used to obtain all the relevant IAB strings already mapped
    /// to Core's ``ConsentKey`` constants.
    public var userDefaultsIABStrings: [ConsentKey: ConsentValue] {
        UserDefaultsIABStringObserver.userDefaultsIABStrings
    }

    /// Adds an observer to get notified whenever IAB strings stored in UserDefaults change.
    /// If the CMP follows the IAB standard this can be used to start observing consent changes
    /// on initialization and have chages automatically trigger the appropriate ``ConsentAdapterDelegate``
    /// methods.
    ///
    /// Just make sure to call this method on a successful initialization and keep the returned observer object
    /// alive in your adapter instance.
    ///
    /// - returns: An observer object that must be kept alive in the adapter.
    public func startObservingUserDefaultsIABStrings() -> Any {
        UserDefaultsIABStringObserver(adapter: self)
    }
}

/// An observer that makes the proper ``ConsentAdapterDelegate`` calls whenever IAB strings change in
/// the UserDefaults.
private final class UserDefaultsIABStringObserver: NSObject {
    private enum IABUserDefaultsKey {
        static let tcf = "IABTCF_TCString"
        static let gpp = "IABGPP_HDR_GppString"
        static let usp = "IABUSPrivacy_String"
    }

    private weak var adapter: ConsentAdapter?

    init(adapter: ConsentAdapter) {
        self.adapter = adapter
        super.init()
        startObservingUserDefaultsIABStrings()
    }

    deinit {
        stopObservingUserDefaultsIABStrings()
    }

    /// The IAB consent strings currently stored in UserDefaults.
    static var userDefaultsIABStrings: [ConsentKey: ConsentValue] {
        var consents: [ConsentKey: ConsentValue] = [:]
        consents[ConsentKeys.gpp] = UserDefaults.standard.string(forKey: IABUserDefaultsKey.gpp)
        consents[ConsentKeys.tcf] = UserDefaults.standard.string(forKey: IABUserDefaultsKey.tcf)
        consents[ConsentKeys.usp] = UserDefaults.standard.string(forKey: IABUserDefaultsKey.usp)
        return consents
    }

    private func startObservingUserDefaultsIABStrings() {
        UserDefaults.standard.addObserver(self, forKeyPath: IABUserDefaultsKey.tcf, context: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: IABUserDefaultsKey.gpp, context: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: IABUserDefaultsKey.usp, context: nil)
    }

    private func stopObservingUserDefaultsIABStrings() {
        UserDefaults.standard.removeObserver(self, forKeyPath: IABUserDefaultsKey.tcf)
        UserDefaults.standard.removeObserver(self, forKeyPath: IABUserDefaultsKey.gpp)
        UserDefaults.standard.removeObserver(self, forKeyPath: IABUserDefaultsKey.usp)
    }

    // swiftlint:disable block_based_kvo
    // Implemented traditional KVO for IAB strings because block based KVO implementation does not work if the value is not
    // accessed via the associated custom `@dynamic var` getters and setters.
    // In the case of IAB strings, they are set by third parties via the built-in `UserDefaults.standard.set()` call.
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard let adapter else {
            return
        }
        let value = UserDefaults.standard.value(forKey: keyPath ?? "") ?? ""
        adapter.log("User defaults change, key: '\(keyPath ?? "")' value: '\(value)'", level: .verbose)

        // Call corresponding adapter delegate method
        switch keyPath {
        case IABUserDefaultsKey.tcf:
            adapter.delegate?.onConsentChange(key: ConsentKeys.tcf)
        case IABUserDefaultsKey.gpp:
            adapter.delegate?.onConsentChange(key: ConsentKeys.gpp)
        case IABUserDefaultsKey.usp:
            adapter.delegate?.onConsentChange(key: ConsentKeys.usp)
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    // swiftlint:enable block_based_kvo
}
