// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import ChartboostCoreConsentAdapterUsercentrics
import Usercentrics

/// Code demo for how to use the `ChartboostCore` SDK.
final class ChartboostCoreAdapter_Swift {
    static let shared = ChartboostCoreAdapter_Swift()

    /// Initialize the `ChartboostCore` SDK with hardcoded parameters.
    func initializeSDK() {
        let sdkConfig = SDKConfiguration(chartboostAppID: "your_chartboost_app_id")

        // This demo uses the Usercentrics SDK as the CMP (Consent Management Platform) SDK, which
        // is wrapped by a Chartboost developed adapter `UsercentricsAdapter`.
        //
        // You can choose any CMP SDK of your choice, wrap it with an adapter that conforms to
        // the `ConsentAdapter` protocol, and assign it to the `cmpModule` here.
        //
        // Note: The Usercentrics SDK does not work without a valid Settings ID.
        let cmpModule = UsercentricsAdapter(
            options: UsercentricsOptions(settingsId: "your_usercentrics_settings_id")
        )

        let customModule_ObjC = CustomInitializableModule_ObjC(
            string: "some value 1",
            andNumber: 123
        )

        let customModule_Swift = CustomInitializableModule_Swift(
            customString: "some value 2",
            customNumber: 234
        )

        // Add a `ConsentObserver` observer (which is `self` in this demo) to receive consent update
        // callbacks after the user denied or granted consent.
        // Consent observer can be added before or after the `initializeSDK` call.
        // Adding the same observer multiple times does not multiplex the callbacks.
        ChartboostCore.consent.addObserver(self)

        // The `modules` array should container one and only one CMP (Consent Management Platform) module.
        // If multiple CMP modules (`ConsentAdapter`) are provided, only the first one will be initialized
        // with the other CMP modules ignored.
        //
        // This call initializes the Chartboost Core SDK. Although `moduleObserver` is optional, providing
        // a `InitializableModuleObserver` is very helpful for receiving callbacks to know whether the
        // provided modules were initilized successfully.
        ChartboostCore.initializeSDK(
            with: sdkConfig,
            modules: [cmpModule, customModule_ObjC, customModule_Swift],
            moduleObserver: self
        )
    }

    func resetConsent() {
        ChartboostCore.consent.resetConsent() { succeeded in
            let logItem = LogItem(
                text: "[Swift] Reset consent",
                secondaryText: "Result: succeeded = \(succeeded)"
            )
            NotificationCenter.default.post(name: .newLog, object: logItem)
        }
    }

    func denyConsent() {
        ChartboostCore.consent.denyConsent(source: .user) { succeeded in
            let logItem = LogItem(
                text: "[Swift] Deny consent",
                secondaryText: "Result: succeeded = \(succeeded)"
            )
            NotificationCenter.default.post(name: .newLog, object: logItem)
        }
    }

    func grantConsent() {
        ChartboostCore.consent.grantConsent(source: .user) { succeeded in
            let logItem = LogItem(
                text: "[Swift] Grant consent",
                secondaryText: "Result: succeeded = \(succeeded)"
            )
            NotificationCenter.default.post(name: .newLog, object: logItem)
        }
    }

    func showConsentDialog(consentDialogType: ConsentDialogType, from viewController: UIViewController) {
        ChartboostCore.consent.showConsentDialog(consentDialogType, from: viewController) { succeeded in
            let logItem = LogItem(
                text: "[Swift] Show consent dialog: \(consentDialogType)",
                secondaryText: "Result: succeeded = \(succeeded)"
            )
            NotificationCenter.default.post(name: .newLog, object: logItem)
        }
    }
}

extension ChartboostCoreAdapter_Swift: ConsentObserver {
    func onConsentModuleReady() {
        let logItem = LogItem(
            text: "[Swift] onConsentModuleReady",
            secondaryText: nil
        )
        NotificationCenter.default.post(name: .newLog, object: logItem)
    }

    func onConsentChange(standard: ConsentStandard, value: ConsentValue?) {
        let logItem = LogItem(
            text: "[Swift] onConsentChange",
            secondaryText: "ConsentStandard: \(standard), ConsentValue: \(value?.description ?? "nil")"
        )
        NotificationCenter.default.post(name: .newLog, object: logItem)
    }

    func onConsentStatusChange(_ status: ConsentStatus) {
        let logItem = LogItem(
            text: "[Swift] onConsentStatusChange",
            secondaryText: "ConsentStatus = \(status)"
        )
        NotificationCenter.default.post(name: .newLog, object: logItem)
    }
}

extension ChartboostCoreAdapter_Swift: InitializableModuleObserver {
    func onModuleInitializationCompleted(_ result: ModuleInitializationResult) {
        let logItem = LogItem(
            text: "[Swift] Module init: \(result.module.moduleID)",
            secondaryText: "Result: error = \(result.error?.localizedDescription ?? "nil")"
        )
        NotificationCenter.default.post(name: .newLog, object: logItem)
    }
}
