// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import UIKit

/// The protocol to which a CMP adapter module must conform to.
///
/// Core SDK identifies a CMP adapter from the list of modules it initializes based on conformance to this protocol.
/// When the publisher uses Core's CMP APIs (the ``ChartboostCore/consent``) method calls are forwarded to a Core module
/// that conforms to ``ConsentAdapter``, and such a module is also expected to report consent status changes back to the
/// Core SDK via its ``delegate`` property.
public protocol ConsentAdapter: InitializableModule {

    /// Indicates whether the CMP has determined that consent should be collected from the user.
    var shouldCollectConsent: Bool { get }

    /// The current consent status determined by the CMP.
    var consentStatus: ConsentStatus { get }

    /// Individualized consent status per partner SDK.
    ///
    /// The keys for advertising SDKs should match Chartboost Mediation partner adapter ids.
    var partnerConsentStatus: [String: ConsentStatus] { get }

    /// Detailed consent status for each consent standard, as determined by the CMP.
    ///
    /// Predefined consent standard constants, such as ``ConsentStandard/usp`` and ``ConsentStandard/tcf``, are provided
    /// by Core. Adapters should use them when reporting the status of a common standard.
    /// Custom standards should only be used by adapters when a corresponding constant is not provided by the Core.
    ///
    /// While Core also provides consent value constants, these are only applicable for the ``ConsentStandard/ccpaOptIn`` and
    /// ``ConsentStandard/gdprConsentGiven`` standards. For other standards a custom value should be provided (e.g. a IAB TCF string
    /// for ``ConsentStandard/tcf``).
    var consents: [ConsentStandard: ConsentValue] { get }

    /// The delegate to be notified whenever any change happens in the CMP consent status.
    /// This delegate is set by Core SDK and is an essential communication channel between Core and the CMP.
    /// Adapters should not set it themselves.
    var delegate: ConsentAdapterDelegate? { get set }

    /// Instructs the CMP to present a consent dialog to the user for the purpose of collecting consent.
    /// - parameter type: The type of consent dialog to present. See the ``ConsentDialogType`` documentation for more info.
    /// If the CMP does not support a given type, it should default to whatever type it does support.
    /// - parameter viewController: The view controller to present the consent dialog from.
    /// - parameter completion: This handler is called to indicate whether the consent dialog was successfully presented or not.
    /// Note that this is called at the moment the dialog is presented, **not when it is dismissed**.
    func showConsentDialog(_ type: ConsentDialogType, from viewController: UIViewController, completion: @escaping (_ succeeded: Bool) -> Void)

    /// Informs the CMP that the user has granted consent.
    /// This method should be used only when a custom consent dialog is presented to the user, thereby making the publisher
    /// responsible for the UI-side of collecting consent. In most cases ``showConsentDialog(_:from:completion:)`` should
    /// be used instead.
    /// If the CMP does not support custom consent dialogs or the operation fails for any other reason, the completion
    /// handler is executed with a `false` parameter.
    /// - parameter source: The source of the new consent. See the ``ConsentStatusSource`` documentation for more info.
    /// - parameter completion: Handler called to indicate if the operation went through successfully or not.
    func grantConsent(source: ConsentStatusSource, completion: @escaping (_ succeeded: Bool) -> Void)

    /// Informs the CMP that the user has denied consent.
    /// This method should be used only when a custom consent dialog is presented to the user, thereby making the publisher
    /// responsible for the UI-side of collecting consent. In most cases ``showConsentDialog(_:from:completion:)`` should
    /// be used instead.
    /// If the CMP does not support custom consent dialogs or the operation fails for any other reason, the completion
    /// handler is executed with a `false` parameter.
    /// - parameter source: The source of the new consent. See the ``ConsentStatusSource`` documentation for more info.
    /// - parameter completion: Handler called to indicate if the operation went through successfully or not.
    func denyConsent(source: ConsentStatusSource, completion: @escaping (_ succeeded: Bool) -> Void)

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
        Logger(subsystem: "com.chartboost.core.adapter", category: "\(moduleID) adapter")
            .log(message, level: level)
    }
}
