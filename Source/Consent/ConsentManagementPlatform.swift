// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import UIKit

/// Chartboost Core's CMP in charge of handling user consent management.
/// Chartboost Core defines a unified API for publishers to request and query user consent,
/// and relies on a 3rd-party CMP SDK to provide the CMP functionality.
///
/// Note that a ``ConsentAdapter`` module must be integrated to enable Core's
/// All methods are no-ops unless a ``ConsentAdapter`` Core module is integrated in the app and initialized.
/// ``ConsentObserver`` objects passed on a call to ``addObserver(_:)`` will get a call to ``ConsentObserver/onConsentModuleReady()``
/// when the ``ConsentAdapter`` is initialized and the ``ConsentManagementPlatform`` is ready to be used.
@objc(CBCConsentManagementPlatform)
public protocol ConsentManagementPlatform: AnyObject {

    /// Indicates whether the CMP has determined that consent should be collected from the user.
    /// Returns `false` if no consent adapter module is available.
    var shouldCollectConsent: Bool { get }

    /// The current consent status determined by the CMP.
    /// Returns ``ConsentStatus/unknown`` if no consent adapter module is available.
    var consentStatus: ConsentStatus { get }

    /// Individualized consent status per partner SDK, as determined by the CMP.
    /// The keys for advertising SDKs should match Chartboost Mediation partner adapter ids.
    ///
    /// For compatibility with Obj-C, the values are the Int representation of a ``ConsentStatus``.
    /// You may use the more idiomatic ``partnerConsentStatus`` in Swift instead.
    ///
    /// Returns an empty dictionary if no consent adapter module is available.
    var objc_partnerConsentStatus: [String: NSNumber] { get }

    /// Detailed consent status for each consent standard, as determined by the CMP.
    /// Returns an empty dictionary if no consent adapter module is available.
    var consents: [ConsentStandard: ConsentValue] { get }

    /// Instructs the CMP to present a consent dialog to the user for the purpose of collecting consent.
    /// - parameter type: The type of consent dialog to present. See the ``ConsentDialogType`` documentation for more info.
    /// If the CMP does not support a given type, it should default to whatever type it does support.
    /// - parameter viewController: The view controller to present the consent dialog from.
    /// - parameter completion: This handler is called to indicate whether the consent dialog was successfully presented or not.
    /// Note that this is called at the moment the dialog is presented, **not when it is dismissed**.
    ///
    /// If no consent adapter module is available this method does nothing.
    func showConsentDialog(_ type: ConsentDialogType, from viewController: UIViewController, completion: @escaping (_ succeeded: Bool) -> Void)

    /// Informs the CMP that the user has granted consent.
    /// This method should be used only when a custom consent dialog is presented to the user, thereby making the publisher
    /// responsible for the UI-side of collecting consent. In most cases ``showConsentDialog(_:from:completion:)`` should
    /// be used instead.
    /// If the CMP does not support custom consent dialogs or the operation fails for any other reason, the completion
    /// handler is executed with a `false` parameter.
    /// - parameter source: The source of the new consent. See the ``ConsentStatusSource`` documentation for more info.
    /// - parameter completion: Handler called to indicate if the operation went through successfully or not.
    ///
    /// If no consent adapter module is available this method does nothing.
    func grantConsent(source: ConsentStatusSource, completion: @escaping (_ succeeded: Bool) -> Void)

    /// Informs the CMP that the user has denied consent.
    /// This method should be used only when a custom consent dialog is presented to the user, thereby making the publisher
    /// responsible for the UI-side of collecting consent. In most cases ``showConsentDialog(_:from:completion:)`` should
    /// be used instead.
    /// If the CMP does not support custom consent dialogs or the operation fails for any other reason, the completion
    /// handler is executed with a `false` parameter.
    /// - parameter source: The source of the new consent. See the ``ConsentStatusSource`` documentation for more info.
    /// - parameter completion: Handler called to indicate if the operation went through successfully or not.
    ///
    /// If no consent adapter module is available this method does nothing.
    func denyConsent(source: ConsentStatusSource, completion: @escaping (_ succeeded: Bool) -> Void)

    /// Informs the CMP that the given consent should be reset.
    /// If the CMP does not support the `reset()` function or the operation fails for any other reason, the completion
    /// handler is executed with a `false` parameter.
    /// - parameter completion: Handler called to indicate if the operation went through successfully or not.
    ///
    /// If no consent adapter module is available this method does nothing.
    func resetConsent(completion: @escaping (_ succeeded: Bool) -> Void)

    /// Adds an observer to receive notifications whenever the CMP consent status changes.
    /// The Core SDK automatically notifies modules that conform to ``ConsentObserver`` about these changes, so there is no need
    /// to manually add Core modules as observers.
    ///
    /// It is okay to add an observer before a consent adapter module is set.
    func addObserver(_ observer: ConsentObserver)

    /// Removes a previously-added observer.
    func removeObserver(_ observer: ConsentObserver)
}

extension ConsentManagementPlatform {

    /// Individualized consent status per partner SDK, as determined by the CMP.
    /// The keys for advertising SDKs should match Chartboost Mediation partner adapter ids.
    ///
    /// Returns an empty dictionary if no consent adapter module is available.
    public var partnerConsentStatus: [String: ConsentStatus] {
        objc_partnerConsentStatus.compactMapValues {
            ConsentStatus(rawValue: $0.intValue)
        }
    }
}

// Convenience methods with default arguments.
public extension ConsentManagementPlatform {

    /// Informs the CMP that the user has granted consent.
    /// This method should be used only when a custom consent dialog is presented to the user, thereby making the publisher
    /// responsible for the UI-side of collecting consent. In most cases ``showConsentDialog(_:from:completion:)`` should
    /// be used instead.
    /// - parameter source: The source of the new consent. See the ``ConsentStatusSource`` documentation for more info.
    ///
    /// If no consent adapter module is available this method does nothing.
    func grantConsent(source: ConsentStatusSource) {
        grantConsent(source: source, completion: { _ in })
    }

    /// Informs the CMP that the user has denied consent.
    /// This method should be used only when a custom consent dialog is presented to the user, thereby making the publisher
    /// responsible for the UI-side of collecting consent. In most cases ``showConsentDialog(_:from:completion:)`` should
    /// be used instead.
    /// - parameter source: The source of the new consent. See the ``ConsentStatusSource`` documentation for more info.
    ///
    /// If no consent adapter module is available this method does nothing.
    func denyConsent(source: ConsentStatusSource) {
        denyConsent(source: source, completion: { _ in })
    }

    /// Informs the CMP that the given consent should be reset.
    ///
    /// If no consent adapter module is available this method does nothing.
    func resetConsent() {
        resetConsent(completion: { _ in })
    }

    /// Instructs the CMP to present a consent dialog to the user for the purpose of collecting consent.
    /// - parameter type: The type of consent dialog to present. See the ``ConsentDialogType`` documentation for more info.
    /// If the CMP does not support a given type, it should default to whatever type it does support.
    /// - parameter viewController: The view controller to present the consent dialog from.
    func showConsentDialog(_ type: ConsentDialogType, from viewController: UIViewController) {
        showConsentDialog(type, from: viewController, completion: { _ in })
    }
}

/// A type that serves as a proxy for a consent adapter.
protocol ConsentAdapterProxy: AnyObject {

    /// The consent adapter that the proxy represents.
    var adapter: ConsentAdapter? { get set }
}

/// Core's concrete implementation of ``ConsentManagementPlatform``.
/// This class acts as a consent adapter proxy, forwarding method calls to whatever adapter module is available.
/// It also manages the consent observers added by the publisher and forwards consent updates to them.
final class ChartboostCoreConsentManagementPlatform: ConsentManagementPlatform, ConsentAdapterProxy, ConsentAdapterDelegate {

    @Injected(\.sessionInfoProvider) private var sessionInfoProvider

    // List of observers added by the publisher.
    @Atomic private var observers: [WeakWrapper<ConsentObserver>] = []

    /// The last consent status provided by the CMP.
    /// We keep track of this to identify changes that require resetting the app session.
    private var lastConsentStatus: ConsentStatus = .unknown

    // MARK: ConsentAdapterProxy

    // We observe consent changes on the CMP adapter module.
    // When we receive an update we forward it to other observers and reset the ChartboostCore session when needed.
    var adapter: ConsentAdapter? {
        willSet {
            adapter?.delegate = nil
        }
        didSet {
            adapter?.delegate = self

            // When the adapter is first set we inform observers that the new consent info is available.
            logger.debug("Initial consent info available")

            // Forward call to external observers (modules and publisher observers)
            forAllObservers {
                $0.onConsentModuleReady()
            }
        }
    }

    // MARK: ConsentManagementPlatform
    
    var shouldCollectConsent: Bool {
        adapter?.shouldCollectConsent ?? false
    }

    var consentStatus: ConsentStatus {
        adapter?.consentStatus ?? .unknown
    }

    var objc_partnerConsentStatus: [String : NSNumber] {
        adapter?.partnerConsentStatus.mapValues { NSNumber(integerLiteral: $0.rawValue) } ?? [:]
    }

    var consents: [ConsentStandard: ConsentValue] {
        adapter?.consents ?? [:]
    }

    func showConsentDialog(_ type: ConsentDialogType, from viewController: UIViewController, completion: @escaping (_ succeeded: Bool) -> Void) {
        guard let adapter else {
            logger.warning("showConsentDialog() had no effect because no CMP adapter is set.")
            completion(false)
            return
        }
        adapter.showConsentDialog(type, from: viewController, completion: completion)
    }

    func grantConsent(source: ConsentStatusSource, completion: @escaping (_ succeeded: Bool) -> Void) {
        guard let adapter else {
            logger.warning("grantConsent() had no effect because no CMP adapter is set.")
            completion(false)
            return
        }
        adapter.grantConsent(source: source, completion: completion)
    }

    func denyConsent(source: ConsentStatusSource, completion: @escaping (_ succeeded: Bool) -> Void) {
        guard let adapter else {
            logger.warning("denyConsent() had no effect because no CMP adapter is set.")
            completion(false)
            return
        }
        adapter.denyConsent(source: source, completion: completion)
    }

    func resetConsent(completion: @escaping (_ succeeded: Bool) -> Void) {
        guard let adapter else {
            logger.warning("resetConsent() had no effect because no CMP adapter is set.")
            completion(false)
            return
        }
        adapter.resetConsent(completion: completion)
    }

    func addObserver(_ observer: ConsentObserver) {
        guard !observers.contains(where: { $0.value === observer }) else {
            logger.info("Consent observer not added: the object is already observing consent.")
            return
        }
        observers.append(WeakWrapper(observer))
    }

    func removeObserver(_ observer: ConsentObserver) {
        observers.removeAll(where: { $0.value === observer })
    }
}

// MARK: - ConsentAdapterDelegate

extension ChartboostCoreConsentManagementPlatform {

    func onConsentStatusChange(_ status: ConsentStatus) {
        logger.debug("Consent status changed to \(status)")

        // Reset app session if status changes from granted to another value
        if lastConsentStatus == .granted && status != .granted {
            logger.info("Resetting app session due to consent status change to \(status)")
            sessionInfoProvider.reset()
        }
        lastConsentStatus = status

        // Forward call to external observers (modules and publisher observers)
        forAllObservers {
            $0.onConsentStatusChange(status)
        }
    }

    func onPartnerConsentStatusChange(partnerID: String, status: ConsentStatus) {
        logger.debug("Consent status for partner '\(partnerID)' changed to \(status)")

        // Forward call to external observers (modules and publisher observers)
        forAllObservers {
            $0.onPartnerConsentStatusChange(partnerID: partnerID, status: status)
        }
    }

    func onConsentChange(standard: ConsentStandard, value: ConsentValue?) {
        logger.debug("Consent for standard '\(standard)' changed to \(value ?? "nil")")

        // Forward call to external observers (modules and publisher observers)
        forAllObservers {
            $0.onConsentChange(standard: standard, value: value)
        }
    }

    /// Iterates over all the observers in a thread-safe way, cleaning up references to any deallocated observers.
    private func forAllObservers(handler: @escaping (ConsentObserver) -> Void) {
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
