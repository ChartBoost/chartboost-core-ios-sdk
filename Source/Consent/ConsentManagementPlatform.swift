// Copyright 2023-2024 Chartboost, Inc.
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
/// ``ConsentObserver`` objects passed on a call to ``addObserver(_:)`` will get a call to 
/// ``ConsentObserver/onConsentModuleReady(initialConsents:)`` when the ``ConsentAdapter`` is initialized
/// and the ``ConsentManagementPlatform`` is ready to be used.
@objc(CBCConsentManagementPlatform)
public protocol ConsentManagementPlatform: AnyObject {
    /// Indicates whether the CMP has determined that consent should be collected from the user.
    /// Returns `false` if no consent adapter module is available.
    var shouldCollectConsent: Bool { get }

    /// Current user consent info as determined by the CMP.
    ///
    /// Consent info may include IAB strings, like TCF or GPP, and parsed boolean-like signals like "CCPA Opt In Sale"
    /// and partner-specific signals.
    ///
    /// Make sure to use predefined consent key constants defined in ``ConsentKeys`` to access specific entries in
    /// the dictionary. You may use predefined consent value constants defined in ``ConsentValues`` for comparing
    /// values of non-IAB strings (for example ``ConsentKeys/ccpaOptIn`` and ``ConsentKeys/gdprConsentGiven``).
    ///
    /// Returns an empty dictionary if no consent adapter module is available.
    var consents: [ConsentKey: ConsentValue] { get }

    /// Instructs the CMP to present a consent dialog to the user for the purpose of collecting consent.
    /// - parameter type: The type of consent dialog to present. See the ``ConsentDialogType`` documentation for more info.
    /// If the CMP does not support a given type, it should default to whatever type it does support.
    /// - parameter viewController: The view controller to present the consent dialog from.
    /// - parameter completion: This handler is called to indicate whether the consent dialog was successfully presented or not.
    /// Note that this is called at the moment the dialog is presented, **not when it is dismissed**.
    ///
    /// If no consent adapter module is available this method does nothing.
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
    ///
    /// If no consent adapter module is available this method does nothing.
    func grantConsent(source: ConsentSource, completion: @escaping (_ succeeded: Bool) -> Void)

    /// Informs the CMP that the user has denied consent.
    /// This method should be used only when a custom consent dialog is presented to the user, thereby making the publisher
    /// responsible for the UI-side of collecting consent. In most cases ``showConsentDialog(_:from:completion:)`` should
    /// be used instead.
    /// If the CMP does not support custom consent dialogs or the operation fails for any other reason, the completion
    /// handler is executed with a `false` parameter.
    /// - parameter source: The source of the new consent. See the ``ConsentSource`` documentation for more info.
    /// - parameter completion: Handler called to indicate if the operation went through successfully or not.
    ///
    /// If no consent adapter module is available this method does nothing.
    func denyConsent(source: ConsentSource, completion: @escaping (_ succeeded: Bool) -> Void)

    /// Informs the CMP that the given consent should be reset.
    /// If the CMP does not support the `reset()` function or the operation fails for any other reason, the completion
    /// handler is executed with a `false` parameter.
    /// - parameter completion: Handler called to indicate if the operation went through successfully or not.
    ///
    /// If no consent adapter module is available this method does nothing.
    func resetConsent(completion: @escaping (_ succeeded: Bool) -> Void)

    /// Adds an observer to receive notifications whenever the CMP consent info changes.
    /// The Core SDK automatically notifies modules that conform to ``ConsentObserver`` about these changes, so there is no need
    /// to manually add Core modules as observers.
    ///
    /// It is okay to add an observer before a consent adapter module is set.
    func addObserver(_ observer: ConsentObserver)

    /// Removes a previously-added observer.
    func removeObserver(_ observer: ConsentObserver)
}

// Convenience methods with default arguments.
extension ConsentManagementPlatform {
    /// Informs the CMP that the user has granted consent.
    /// This method should be used only when a custom consent dialog is presented to the user, thereby making the publisher
    /// responsible for the UI-side of collecting consent. In most cases ``showConsentDialog(_:from:completion:)`` should
    /// be used instead.
    /// - parameter source: The source of the new consent. See the ``ConsentSource`` documentation for more info.
    ///
    /// If no consent adapter module is available this method does nothing.
    public func grantConsent(source: ConsentSource) {
        grantConsent(source: source, completion: { _ in })
    }

    /// Informs the CMP that the user has denied consent.
    /// This method should be used only when a custom consent dialog is presented to the user, thereby making the publisher
    /// responsible for the UI-side of collecting consent. In most cases ``showConsentDialog(_:from:completion:)`` should
    /// be used instead.
    /// - parameter source: The source of the new consent. See the ``ConsentSource`` documentation for more info.
    ///
    /// If no consent adapter module is available this method does nothing.
    public func denyConsent(source: ConsentSource) {
        denyConsent(source: source, completion: { _ in })
    }

    /// Informs the CMP that the given consent should be reset.
    ///
    /// If no consent adapter module is available this method does nothing.
    public func resetConsent() {
        resetConsent(completion: { _ in })
    }

    /// Instructs the CMP to present a consent dialog to the user for the purpose of collecting consent.
    /// - parameter type: The type of consent dialog to present. See the ``ConsentDialogType`` documentation for more info.
    /// If the CMP does not support a given type, it should default to whatever type it does support.
    /// - parameter viewController: The view controller to present the consent dialog from.
    public func showConsentDialog(_ type: ConsentDialogType, from viewController: UIViewController) {
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
    @Injected(\.appConfig) private var appConfig
    @Injected(\.sessionInfoProvider) private var sessionInfoProvider

    // List of observers added by the publisher.
    @Atomic private var observers: [WeakWrapper<ConsentObserver>] = []

    /// List of keys received on ``ConsentAdapterDelegate/onConsentChange(key:)`` calls, waiting to be reported
    /// as changes to observers in a batch.
    private var batchedConsentChangeKeys: Set<ConsentKey> = []

    /// The timer scheduled to report consent changes in batch after a small delay.
    private var batchedConsentChangeTimer: Timer?

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
            let initialConsents = consents
            forAllObservers {
                $0.onConsentModuleReady(initialConsents: initialConsents)
            }
        }
    }

    // MARK: ConsentManagementPlatform

    var shouldCollectConsent: Bool {
        adapter?.shouldCollectConsent ?? false
    }

    var consents: [ConsentKey: ConsentValue] {
        adapter?.consents ?? [:]
    }

    func showConsentDialog(
        _ type: ConsentDialogType,
        from viewController: UIViewController,
        completion: @escaping (_ succeeded: Bool) -> Void
    ) {
        guard let adapter else {
            logger.warning("showConsentDialog() had no effect because no CMP adapter is set.")
            completion(false)
            return
        }
        adapter.showConsentDialog(type, from: viewController, completion: completion)
    }

    func grantConsent(source: ConsentSource, completion: @escaping (_ succeeded: Bool) -> Void) {
        guard let adapter else {
            logger.warning("grantConsent() had no effect because no CMP adapter is set.")
            completion(false)
            return
        }
        adapter.grantConsent(source: source, completion: completion)
    }

    func denyConsent(source: ConsentSource, completion: @escaping (_ succeeded: Bool) -> Void) {
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
    func onConsentChange(key: ConsentKey) {
        logger.debug("Consent for key '\(key)' changed")

        let delay = appConfig.consentUpdateBatchDelay
        if delay <= 0 {   // Batching disabled
            sendUpdateToObservers(modifiedKeys: [key])
        } else {    // Batching enabled
            // `batchedConsentChangeKeys` and `batchedConsentChangeTimer` protected by accessing them always on the main queue
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                // Add modified key to the batch
                self.batchedConsentChangeKeys.insert(key)
                // Schedule the next update after a small delay, or do nothing it one is already scheduled
                if self.batchedConsentChangeTimer == nil || self.batchedConsentChangeTimer?.isValid != true {
                    self.batchedConsentChangeTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
                        // Clear out batched keys and send update
                        let keys = self.batchedConsentChangeKeys
                        self.batchedConsentChangeKeys = []
                        sendUpdateToObservers(modifiedKeys: keys)
                    }
                }
            }
        }

        // Forward call to external observers (modules and publisher observers)
        func sendUpdateToObservers(modifiedKeys: Set<ConsentKey>) {
            logger.debug("Sending consent update for modified keys: \(modifiedKeys)")
            let fullConsents = consents
            forAllObservers {
                $0.onConsentChange(fullConsents: fullConsents, modifiedKeys: modifiedKeys)
            }
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
