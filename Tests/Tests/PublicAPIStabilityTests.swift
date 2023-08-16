// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import AppTrackingTransparency
import ChartboostCoreSDK
import XCTest

/// Tests to validate that the Core SDK public API remains stable and is not modified by mistake breaking existing integrations.
class PublicAPIStabilityTests: XCTestCase {

    /// Validates the AdvertisingEnvironment public APIs.
    func testAdvertisingEnvironment() {
        let environment: AdvertisingEnvironment = ChartboostCore.advertisingEnvironment
        let _: String? = environment.advertisingID
        let _: String? = environment.bundleID
        let _: String? = environment.deviceLocale
        let _: String = environment.deviceMake
        let _: String = environment.deviceModel
        let _: Bool = environment.isLimitAdTrackingEnabled
        let _: String = environment.osName
        let _: String = environment.osVersion
        let _: Double = environment.screenHeight
        let _: Double = environment.screenScale
        let _: Double = environment.screenWidth
    }

    /// Validates the AnalyticsEnvironment public APIs.
    func testAnalyticsEnvironment() {
        let environment: AnalyticsEnvironment = ChartboostCore.analyticsEnvironment
        let _: ATTrackingManager.AuthorizationStatus = environment.appTrackingTransparencyStatus
        let _: TimeInterval = environment.appSessionDuration
        let _: String? = environment.appSessionID
        let _: String? = environment.appVersion
        let _: String? = environment.advertisingID
        let _: String? = environment.bundleID
        let _: String? = environment.deviceLocale
        let _: String = environment.deviceMake
        let _: String = environment.deviceModel
        let _: String? = environment.frameworkName
        let _: String? = environment.frameworkVersion
        let _: Bool = environment.isLimitAdTrackingEnabled
        let _: Bool = environment.isUserUnderage
        let _: NetworkConnectionType = environment.networkConnectionType
        let _: String = environment.osName
        let _: String = environment.osVersion
        let _: String? = environment.playerID
        let _: String? = environment.publisherAppID
        let _: String? = environment.publisherSessionID
        let _: Double = environment.screenHeight
        let _: Double = environment.screenScale
        let _: Double = environment.screenWidth
        let _: String? = environment.userAgent
        let _: String? = environment.vendorID
        let _: VendorIDScope = environment.vendorIDScope
        let _: Double = environment.volume
    }

    /// Validates the AttributionEnvironment public APIs.
    func testAttributionEnvironment() {
        let environment: AttributionEnvironment = ChartboostCore.attributionEnvironment
        let _: String? = environment.advertisingID
        let _: String? = environment.userAgent
    }

    /// Validates the ChartboostCore public APIs.
    func testChartboostCore() {
        let _: PublisherMetadata = ChartboostCore.publisherMetadata
        let _: AdvertisingEnvironment = ChartboostCore.advertisingEnvironment
        let _: AnalyticsEnvironment = ChartboostCore.analyticsEnvironment
        let _: AttributionEnvironment = ChartboostCore.attributionEnvironment
        let _: ConsentManagementPlatform = ChartboostCore.consent
        let _: String = ChartboostCore.sdkVersion

        ChartboostCore.initializeSDK(with: SDKConfiguration(chartboostAppID: ""), modules: [], moduleObserver: nil)
        ChartboostCore.initializeSDK(with: .init(chartboostAppID: "some app ID"), moduleObserver: self)
        ChartboostCore.initializeSDK(with: SDKConfiguration(chartboostAppID: "some app ID"), modules: [InitializableModuleMock()], moduleObserver: self)
    }

    /// Validates the ChartboostCoreResult public APIs.
    func testChartboostCoreResult() {
        let result: ChartboostCoreResult? = nil
        if let result {
            let _: Date = result.startDate
            let _: Date = result.endDate
            let _: TimeInterval = result.duration
            let _: Error? = result.error
        }
    }

    /// Validates the ConsentAdapter public APIs.
    func testConsentAdapter() {
        let adapter: ConsentAdapter? = nil
        if let adapter {
            let _: Bool = adapter.shouldCollectConsent
            let _: ConsentStatus = adapter.consentStatus
            let _: [ConsentStandard: ConsentValue] = adapter.consents

            let _: ConsentAdapterDelegate? = adapter.delegate
            adapter.delegate = ConsentAdapterDelegateMock()
            adapter.delegate = nil

            adapter.grantConsent(source: .user, completion: { result in
                let _: Bool = result
            })
            adapter.denyConsent(source: .developer) { result in
                let _: Bool = result
            }
            adapter.resetConsent() {
                let _: Bool = $0
            }

            adapter.showConsentDialog(.concise, from: UIViewController(), completion: { result in
                let _: Bool = result
            })
            adapter.showConsentDialog(.detailed, from: UIViewController()) {
                let _: Bool = $0
            }

            let _: String = adapter.moduleID
            let _: String = adapter.moduleVersion

            adapter.initialize { error in
                let _: Error? = error
            }
            adapter.initialize(completion: { (error: Error?) in
                let _: Error? = error
            })

            adapter.log("", level: .trace)
            adapter.log("", level: .debug)
            adapter.log("", level: .info)
            adapter.log("", level: .warning)
            adapter.log("", level: .error)
            adapter.log("", level: .none)
        }
    }

    /// Validates the ConsentDialogType public APIs.
    func testConsentDialogType() {
        let _: ConsentDialogType = .concise
        let _: ConsentDialogType = .detailed
    }

    /// Validates the ConsentManagementPlatform public APIs.
    func testConsentManagementPlatform() {
        let cmp: ConsentManagementPlatform? = nil
        if let cmp {
            let _: Bool = cmp.shouldCollectConsent
            let _: ConsentStatus = cmp.consentStatus
            let _: [ConsentStandard: ConsentValue] = cmp.consents

            cmp.grantConsent(source: .developer)
            cmp.grantConsent(source: .user)
            cmp.denyConsent(source: .developer)
            cmp.denyConsent(source: .user)
            cmp.resetConsent()

            cmp.grantConsent(source: .user, completion: { result in
                let _: Bool = result
            })
            cmp.denyConsent(source: .developer) { result in
                let _: Bool = result
            }
            cmp.resetConsent() {
                let _: Bool = $0
            }

            cmp.showConsentDialog(.concise, from: UIViewController())
            cmp.showConsentDialog(.detailed, from: UIViewController())

            cmp.showConsentDialog(.concise, from: UIViewController(), completion: { result in
                let _: Bool = result
            })
            cmp.showConsentDialog(.detailed, from: UIViewController()) {
                let _: Bool = $0
            }

            cmp.addObserver(self)
            cmp.removeObserver(self)
        }
    }

    /// Validates the ConsentObserver public APIs.
    func testConsentObserver() {
        let observer: ConsentObserver? = nil
        observer?.onConsentModuleReady()
        observer?.onConsentChange(standard: .ccpaOptIn, value: "some value")
        observer?.onConsentChange(standard: "custom standard", value: ConsentValue.denied)
        observer?.onConsentStatusChange(.denied)
    }

    /// Validates the ConsentStandard public APIs.
    func testConsentStandard() {
        let _: ConsentStandard = .ccpaOptIn
        let _: ConsentStandard = .gdprConsentGiven
        let _: ConsentStandard = .gpp
        let _: ConsentStandard = .tcf
        let _: ConsentStandard = .usp

        let _ = ConsentStandard(stringLiteral: "custom standard")
        let _: ConsentStandard = "custom standard"
        let standard = "custom standard"
        let _ = ConsentStandard(stringLiteral: standard)

        let _: String = ConsentStandard.ccpaOptIn.description
    }

    /// Validates the ConsentStatus public APIs.
    func testConsentStatus() {
        let _: ConsentStatus = .unknown
        let _: ConsentStatus = .denied
        let _: ConsentStatus = .granted
    }

    /// Validates the ConsentStatusSource public APIs.
    func testConsentStatusSource() {
        let _: ConsentStatusSource = .user
        let _: ConsentStatusSource = .developer
    }

    /// Validates the ConsentValue public APIs.
    func testConsentValue() {
        let _: ConsentValue = .denied
        let _: ConsentValue = .doesNotApply
        let _: ConsentValue = .granted

        let _ = ConsentValue(stringLiteral: "custom value")
        let _: ConsentValue = "custom value"
        let value = "custom value"
        let _ = ConsentValue(stringLiteral: value)

        let _: String = ConsentValue.granted.description
    }

    /// Validates the InitializableModule public APIs.
    func testInitializableModule() {
        let module: InitializableModule? = nil
        if let module {
            let _: String = module.moduleID
            let _: String = module.moduleVersion

            module.initialize { error in
                let _: Error? = error
            }
            module.initialize(completion: { (error: Error?) in
                let _: Error? = error
            })
        }
    }

    /// Validates the InitializableModuleObserver public APIs.
    func testInitializableModuleObserver() {
        let observer: InitializableModuleObserver? = nil
        let result: ModuleInitializationResult? = nil
        if let result {
            observer?.onModuleInitializationCompleted(result)
        }
    }

    /// Validates the LogLevel public APIs.
    func testLogLevel() {
        let _: LogLevel = .trace
        let _: LogLevel = .debug
        let _: LogLevel = .info
        let _: LogLevel = .warning
        let _: LogLevel = .error
        let _: LogLevel = .none

        let _: Int = LogLevel.info.rawValue
    }

    /// Validates the ModuleInitializationResult public APIs.
    func testModuleInitializationResult() {
        let result: ModuleInitializationResult? = nil
        if let result {
            let _: Date = result.startDate
            let _: Date = result.endDate
            let _: TimeInterval = result.duration
            let _: Error? = result.error
            let _: InitializableModule = result.module
        }
    }

    /// Validates the NetworkConnectionType public APIs.
    func testNetworkConnectionType() {
        let _: NetworkConnectionType = .unknown
        let _: NetworkConnectionType = .wired
        let _: NetworkConnectionType = .wifi
        let _: NetworkConnectionType = .cellularUnknown
        let _: NetworkConnectionType = .cellular2G
        let _: NetworkConnectionType = .cellular3G
        let _: NetworkConnectionType = .cellular4G
        let _: NetworkConnectionType = .cellular5G
    }

    /// Validates the PublisherMetadata public APIs.
    func testPublisherMetadata() {
        let publisherMetadata: PublisherMetadata = ChartboostCore.publisherMetadata
        publisherMetadata.setFrameworkName("")
        publisherMetadata.setFrameworkVersion("")
        publisherMetadata.setIsUserUnderage(true)
        publisherMetadata.setPlayerID("")
        publisherMetadata.setPublisherAppID("")
        publisherMetadata.setPublisherSessionID("")
    }

    /// Validates the SDKConfiguration public APIs.
    func testSDKConfiguration() {
        let configuration = SDKConfiguration(chartboostAppID: "some id")
        let _: String = configuration.chartboostAppID
    }

    /// Validates the VendorIDScope public APIs.
    func testVendorIDScope() {
        let _: VendorIDScope = .unknown
        let _: VendorIDScope = .application
        let _: VendorIDScope = .developer
    }
}

extension PublicAPIStabilityTests: ConsentObserver {

    func onConsentModuleReady() {
        
    }

    func onConsentStatusChange(_ status: ConsentStatus) {

    }

    func onConsentChange(standard: ConsentStandard, value: ConsentValue?) {

    }
}

extension PublicAPIStabilityTests: InitializableModuleObserver {

    func onModuleInitializationCompleted(_ result: ModuleInitializationResult) {

    }
}

class PublicAPIStabilityTestsInitializableModule: InitializableModule {

    var moduleID: String { "" }

    var moduleVersion: String { "" }

    required init(credentials: [String : Any]?) {

    }

    func initialize(
        completion: @escaping (Error?) -> Void
    ) {

    }
}

class PublicAPIStabilityTestsConsentAdapter: ConsentAdapter {

    var moduleID: String { "" }

    var moduleVersion: String { "" }

    required init(credentials: [String : Any]?) {

    }

    func initialize(
        completion: @escaping (Error?) -> Void
    ) {

    }

    var delegate: ConsentAdapterDelegate?

    var shouldCollectConsent: Bool {
        false
    }

    var consentStatus: ConsentStatus {
        .denied
    }

    var consents: [ConsentStandard : ConsentValue] {
        [.ccpaOptIn: .denied]
    }

    func grantConsent(source: ConsentStatusSource, completion: @escaping (_ succeeded: Bool) -> Void) {

    }

    func denyConsent(source: ConsentStatusSource, completion: @escaping (_ succeeded: Bool) -> Void) {

    }

    func resetConsent(completion: @escaping (_ succeeded: Bool) -> Void) {

    }

    func showConsentDialog(_ type: ConsentDialogType, from viewController: UIViewController, completion: @escaping (_ succeeded: Bool) -> Void) {

    }
}

extension PublicAPIStabilityTests: ConsentManagementPlatform {

    var shouldCollectConsent: Bool {
        false
    }

    var consentStatus: ConsentStatus {
        .denied
    }

    var consents: [ConsentStandard : ConsentValue] {
        [.ccpaOptIn: .denied]
    }

    func grantConsent(source: ConsentStatusSource, completion: @escaping (_ succeeded: Bool) -> Void) {

    }

    func denyConsent(source: ConsentStatusSource, completion: @escaping (_ succeeded: Bool) -> Void) {

    }

    func resetConsent(completion: @escaping (_ succeeded: Bool) -> Void) {

    }

    func showConsentDialog(_ type: ConsentDialogType, from viewController: UIViewController, completion: @escaping (_ succeeded: Bool) -> Void) {
        
    }

    func addObserver(_ observer: ConsentObserver) {

    }

    func removeObserver(_ observer: ConsentObserver) {

    }
}
