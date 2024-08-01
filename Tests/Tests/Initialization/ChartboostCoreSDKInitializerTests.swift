// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class ChartboostCoreSDKInitializerTests: ChartboostCoreTestCase {
    let initializer = ChartboostCoreSDKInitializer()

    lazy var configuration = SDKConfiguration(
        chartboostAppID: "",
        modules: attemptedModules,
        skippedModuleIDs: []
    )
    let attemptedModules = [
        ModuleMock(moduleID: "module1"),
        ModuleMock(moduleID: "module2"),
        ConsentAdapterMock(moduleID: "module3_cmp"),
        ConsentAdapterMock(moduleID: "module4_cmp_dropped"), // only the first `ConsentAdapter` is initialized
    ]
    lazy var expectedModules = attemptedModules.dropLast() // drop the last `ConsentAdapter` which won't be initilized
    let modulesObserver = ModuleObserverMock()

    /// Validates that a call to `initializeSDK()` makes the session start and the user agent to be fetched.
    func testInitializeTriggersSessionStartAndUserAgentFetchIfNeeded() {
        // Set session and user agent as nil so the initializer recognizes they need to be generated
        mocks.sessionInfoProvider.session = nil
        mocks.userAgentProvider.privateCachedUserAgent = nil

        // Initialize
        initializer.initializeSDK(configuration: configuration, moduleObserver: modulesObserver)
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that session is started and user agent is fetched
        XCTAssertEqual(mocks.sessionInfoProvider.resetCallCount, 1)
        XCTAssertEqual(mocks.userAgentProvider.userAgentFetchCount, 1)
        XCTAssertEqual(mocks.userAgentProvider.privateCachedUserAgent, "some user agent")
    }

    /// Validates that a call to `initializeSDK()` does not make the session start nor the user agent to be fetched
    /// if they're already available.
    func testInitializeDoesNotTriggersSessionStartNorUserAgentFetchIfNotNeeded() {
        // Set session and user agent so the initializer recognizes they do not need to be generated
        mocks.sessionInfoProvider.session = AppSession()
        mocks.userAgentProvider.privateCachedUserAgent = "some user agent"

        // Initialize
        initializer.initializeSDK(configuration: configuration, moduleObserver: modulesObserver)
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that session is not started and user agent is not fetched
        XCTAssertEqual(mocks.sessionInfoProvider.resetCallCount, 0)
        XCTAssertEqual(mocks.userAgentProvider.userAgentFetchCount, 0)
        XCTAssertEqual(mocks.userAgentProvider.privateCachedUserAgent, "some user agent")
    }

    /// Validates that a call to `initializeSDK()` with client-side modules initializes those modules immediately
    /// while fetching the app config in the background.
    func testInitializeWithClientModulesIfNotInitialized() {
        // Set the CMP adapter initial value to nil so it's replaced by the module provided
        mocks.consentManager.adapter = nil

        // Initialize
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallCount, 0)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallErrorCount, 0)
        initializer.initializeSDK(configuration: configuration, moduleObserver: modulesObserver)
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that module initializers were created for each module  and asked to initialize,
        // except the extra `ConsentAdapter` with ID "module4_cmp_dropped".
        XCTAssertEqual(mocks.moduleInitializerFactory.makeModuleInitializerCallCount, expectedModules.count)
        XCTAssertEqual(mocks.moduleInitializerFactory.makeModuleInitializerModuleAllValues.map(\.moduleID), expectedModules.map(\.moduleID))
        let moduleInitializers = mocks.moduleInitializerFactory.makeModuleInitializerReturnValues
        moduleInitializers.forEach {
            XCTAssertEqual($0.initializeCallCount, 1)
        }

        // Check that the module observer has received a call for "module4_cmp_dropped" at this point,
        // while waiting for the other initializers to complete
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallCount, 1)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallErrorCount, 1)

        // Check that the app config fetch happened at the same time
        XCTAssertEqual(mocks.appConfigRepository.fetchAppConfigCallCount, 1)

        // Complete modules initialization and check the observer is called
        let result1 = ModuleInitializationResult(startDate: Date(), error: nil, module: attemptedModules[0])
        moduleInitializers[0].initializeCompletionLastValue?(result1)
        waitForTasksDispatchedOnBackgroundQueue()
        waitForTasksDispatchedOnMainQueue() // observer calls are made on the main queue
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallCount, 2)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallErrorCount, 1)
        XCTAssertIdentical(modulesObserver.onModuleInitializationCompletedResultLastValue, result1)

        let result2 = ModuleInitializationResult(startDate: Date(), error: NSError(domain: "", code: 3), module: attemptedModules[1])
        moduleInitializers[1].initializeCompletionLastValue?(result2)
        waitForTasksDispatchedOnBackgroundQueue()
        waitForTasksDispatchedOnMainQueue() // observer calls are made on the main queue
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallCount, 3)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallErrorCount, 2)
        XCTAssertIdentical(modulesObserver.onModuleInitializationCompletedResultLastValue, result2)

        let result3 = ModuleInitializationResult(startDate: Date(), error: nil, module: attemptedModules[2])
        moduleInitializers[2].initializeCompletionLastValue?(result3)
        waitForTasksDispatchedOnBackgroundQueue()
        waitForTasksDispatchedOnMainQueue() // observer calls are made on the main queue
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallCount, 4)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallErrorCount, 2)
        XCTAssertIdentical(modulesObserver.onModuleInitializationCompletedResultLastValue, result3)

        // Check that CMP was set since one of the modules conforms to ConsentAdapter
        XCTAssertIdentical(mocks.consentManager.adapter, attemptedModules[2])

        // Now make the config fetch finish successfully with no backend-side modules
        mocks.appConfigRepository.config = .build(modules: [])
        mocks.appConfigRepository.fetchAppConfigCompletionLastValue?(nil)
        waitForTasksDispatchedOnBackgroundQueue()

        // Check no more modules where initialized nor calls made to the observer
        XCTAssertEqual(mocks.moduleInitializerFactory.makeModuleInitializerCallCount, expectedModules.count)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallCount, attemptedModules.count)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallErrorCount, 2)
    }

    /// Validates that a call to `initializeSDK()` does not replace the CMP adapter if one was already set.
    func testInitializeWithClientModulesDoesNotSetCMPIfAlreadySet() {
        // Set the CMP adapter initial value
        let existingCMPAdapter = ConsentAdapterMock()
        mocks.consentManager.adapter = existingCMPAdapter

        // Initialize
        initializer.initializeSDK(configuration: configuration, moduleObserver: modulesObserver)
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that CMP was not replaced by one of the new modules
        XCTAssertNotIdentical(mocks.consentManager.adapter, attemptedModules[2])
        XCTAssertIdentical(mocks.consentManager.adapter, existingCMPAdapter)
    }

    /// Validates that a call to `initializeSDK()` with backend-side modules initializes those modules after fetching the app config.
    func testInitializeWithBackendModulesIfNotInitialized() {
        // Set the CMP adapter initial value to nil so it's replaced by the module provided
        mocks.consentManager.adapter = nil
        mocks.appConfigRepository.config = .build(chartboostAppID: nil) // no saved chartboost app ID

        let configuration = SDKConfiguration(chartboostAppID: "", modules: [])

        // Initialize with no client-side modules
        initializer.initializeSDK(configuration: configuration, moduleObserver: modulesObserver)
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that the app config fetch started
        XCTAssertEqual(mocks.appConfigRepository.fetchAppConfigCallCount, 1)
        XCTAssertIdentical(mocks.appConfigRepository.fetchAppConfigConfigurationLastValue, configuration)

        // Make the config fetch finish successfully with some backend-side modules
        let modulesInfo: [AppConfig.ModuleInfo] = [
            .init(className: "ModuleClassName1", nonNativeClassName: nil, identifier: "module1", credentials: JSON(value: ["param1": 2])),
            .init(className: "ModuleClassName2", nonNativeClassName: nil, identifier: "module2", credentials: nil),
            .init(className: nil, nonNativeClassName: "ModuleClassName3", identifier: "module3_cmp", credentials: nil),
        ]
        mocks.appConfigRepository.config = .build(modules: modulesInfo)
        mocks.appConfigRepository.fetchAppConfigCompletionLastValue?(nil)
        // Set the modules to return by the module factory
        mocks.moduleFactory.makeModuleReturnValues = attemptedModules
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that the backend-side modules were instantiated using the module factory
        XCTAssertEqual(mocks.moduleFactory.makeModuleCallCount, 3)
        XCTAssertEqual(mocks.moduleFactory.makeModuleInfoAllValues, modulesInfo)

        // Check that module initializers were created for each module and asked to initialize
        XCTAssertEqual(mocks.moduleInitializerFactory.makeModuleInitializerCallCount, 3)
        XCTAssertEqual(mocks.moduleInitializerFactory.makeModuleInitializerModuleAllValues.map(\.moduleID), expectedModules.map(\.moduleID))
        let moduleInitializers = mocks.moduleInitializerFactory.makeModuleInitializerReturnValues
        moduleInitializers.forEach {
            XCTAssertEqual($0.initializeCallCount, 1)
        }

        // Check that the module observer has not received any call at this point, since we are waiting
        // for the initializers to complete
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallCount, 0)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallErrorCount, 0)

        // Complete modules initialization and check the observer is called
        let result1 = ModuleInitializationResult(startDate: Date(), error: nil, module: attemptedModules[0])
        moduleInitializers[0].initializeCompletionLastValue?(result1)
        waitForTasksDispatchedOnBackgroundQueue()
        waitForTasksDispatchedOnMainQueue() // observer calls are made on the main queue
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallCount, 1)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallErrorCount, 0)
        XCTAssertIdentical(modulesObserver.onModuleInitializationCompletedResultLastValue, result1)

        let result2 = ModuleInitializationResult(startDate: Date(), error: NSError(domain: "", code: 3), module: attemptedModules[1])
        moduleInitializers[1].initializeCompletionLastValue?(result2)
        waitForTasksDispatchedOnBackgroundQueue()
        waitForTasksDispatchedOnMainQueue() // observer calls are made on the main queue
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallCount, 2)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallErrorCount, 1)
        XCTAssertIdentical(modulesObserver.onModuleInitializationCompletedResultLastValue, result2)

        let result3 = ModuleInitializationResult(startDate: Date(), error: nil, module: attemptedModules[2])
        moduleInitializers[2].initializeCompletionLastValue?(result3)
        waitForTasksDispatchedOnBackgroundQueue()
        waitForTasksDispatchedOnMainQueue() // observer calls are made on the main queue
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallCount, 3)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallErrorCount, 1)
        XCTAssertIdentical(modulesObserver.onModuleInitializationCompletedResultLastValue, result3)

        // Check that CMP was set since one of the modules conforms to ConsentAdapter
        XCTAssertIdentical(mocks.consentManager.adapter, attemptedModules[2])

        // Check no more modules where initialized nor calls made to the observer
        XCTAssertEqual(mocks.moduleInitializerFactory.makeModuleInitializerCallCount, 3)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallCount, 3)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallErrorCount, 1)
    }

    /// Validates that a call to `initializeSDK()` does not initialize modules that have the same ID as a module already initialized.
    func testInitializeIgnoresDuplicateModules() {
        // First initialize with 3 client-side modules and 0 backend-side modules
        testInitializeWithClientModulesIfNotInitialized()
        modulesObserver.reset()
        mocks.moduleFactory.reset()
        mocks.moduleInitializerFactory.reset()

        // Initialize again with 1 duplicate and 1 non-duplicate client-side module, 1 duplicate and 1 non-duplicate backend module.
        let clientSideModules = [
            ModuleMock(moduleID: "module1"), // duplicate
            ModuleMock(moduleID: "nondup1"),  // non-duplicate
        ]
        let backendSideModules = [
            ModuleMock(moduleID: "nondup2")  // non-duplicate
        ]
        let modulesInfo: [AppConfig.ModuleInfo] = [
            // duplicate
            .init(className: "ModuleClassName1", nonNativeClassName: nil, identifier: "module3_cmp", credentials: JSON(value: ["p1": 2])),
            // non-duplicate
            .init(className: "ModuleClassName2", nonNativeClassName: nil, identifier: "nondup2", credentials: nil),
        ]
        mocks.appConfigRepository.config = .build(modules: modulesInfo)
        mocks.moduleFactory.makeModuleReturnValues = backendSideModules

        // Initialize
        initializer.initializeSDK(
            configuration: .init(
                chartboostAppID: "",
                modules: clientSideModules
            ),
            moduleObserver: modulesObserver
        )
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that only the non-duplicate backend-side module was instantiated
        // Check that the backend-side modules were instantiated using the module factory
        XCTAssertEqual(mocks.moduleFactory.makeModuleCallCount, 1)
        XCTAssertEqual(mocks.moduleFactory.makeModuleInfoAllValues, [modulesInfo[1]])

        // Check that module initializers were created and initialized for the two non-duplicate modules
        XCTAssertEqual(mocks.moduleInitializerFactory.makeModuleInitializerCallCount, 2)
        XCTAssertEqual(mocks.moduleInitializerFactory.makeModuleInitializerModuleAllValues.map(\.moduleID), ["nondup1", "nondup2"])
        let moduleInitializers = mocks.moduleInitializerFactory.makeModuleInitializerReturnValues
        moduleInitializers.forEach {
            XCTAssertEqual($0.initializeCallCount, 1)
        }

        // Check that calls were made to the module observer for those client-side ignored modules already initialized
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallCount, 1) // corresponds to "module1"
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallErrorCount, 0)

        // Complete modules initialization and check the observer is called
        let result1 = ModuleInitializationResult(startDate: Date(), error: nil, module: clientSideModules[1])
        moduleInitializers[0].initializeCompletionLastValue?(result1)
        waitForTasksDispatchedOnBackgroundQueue()
        waitForTasksDispatchedOnMainQueue() // observer calls are made on the main queue
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallCount, 2)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallErrorCount, 0)
        XCTAssertIdentical(modulesObserver.onModuleInitializationCompletedResultLastValue, result1)

        let result2 = ModuleInitializationResult(startDate: Date(), error: NSError(domain: "", code: 3), module: backendSideModules[0])
        moduleInitializers[1].initializeCompletionLastValue?(result2)
        waitForTasksDispatchedOnBackgroundQueue()
        waitForTasksDispatchedOnMainQueue() // observer calls are made on the main queue
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallCount, 3)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallErrorCount, 1)
        XCTAssertIdentical(modulesObserver.onModuleInitializationCompletedResultLastValue, result2)
    }

    /// Validates that a call to `initializeSDK()` can retry initialization for a module previously failed
    /// to initialize.
    func testInitializeRetriesFailedModules() {
        // First initialize 3 modules with the 2nd one failing
        testInitializeWithClientModulesIfNotInitialized()
        modulesObserver.reset()
        mocks.moduleFactory.reset()
        mocks.moduleInitializerFactory.reset()

        // Initialize again the second module
        let module = attemptedModules[1]
        initializer.initializeSDK(
            configuration: .init(
                chartboostAppID: "",
                modules: [module]
            ),
            moduleObserver: modulesObserver
        )
        waitForTasksDispatchedOnBackgroundQueue()

        // Check a module initializer was created for the module and asked to initialize
        XCTAssertEqual(mocks.moduleInitializerFactory.makeModuleInitializerCallCount, 1)
        XCTAssertEqual(mocks.moduleInitializerFactory.makeModuleInitializerModuleAllValues.first?.moduleID, module.moduleID)
        let moduleInitializer = mocks.moduleInitializerFactory.makeModuleInitializerReturnValues.first
        XCTAssertEqual(moduleInitializer?.initializeCallCount, 1)

        // Complete moduls initialization and check the observer is called
        let result1 = ModuleInitializationResult(startDate: Date(), error: nil, module: module)
        moduleInitializer?.initializeCompletionLastValue?(result1)
        waitForTasksDispatchedOnBackgroundQueue()
        waitForTasksDispatchedOnMainQueue() // observer calls are made on the main queue
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallCount, 1)
        XCTAssertEqual(modulesObserver.onModuleInitializationCompletedCallErrorCount, 0)
        XCTAssertIdentical(modulesObserver.onModuleInitializationCompletedResultLastValue, result1)
    }

    /// Validates that a call to `initializeSDK()` does not set the consent adapter module as the CMP source if
    /// that module fails to initialize.
    func testInitializeDoesNotSetConsentAdapterItItFailedToInitialize() {
        // Set the CMP adapter initial value to nil so it's replaced by the module provided
        mocks.consentManager.adapter = nil

        // Initialize
        initializer.initializeSDK(configuration: configuration, moduleObserver: modulesObserver)
        waitForTasksDispatchedOnBackgroundQueue()

        // Complete the consent module initialization with a failure
        let result = ModuleInitializationResult(startDate: Date(), error: NSError(domain: "", code: 3), module: attemptedModules[2])
        mocks.moduleInitializerFactory.makeModuleInitializerReturnValues[2].initializeCompletionLastValue?(result)
        waitForTasksDispatchedOnBackgroundQueue()
        waitForTasksDispatchedOnMainQueue() // observer calls are made on the main queue

        // Check that CMP module was not set
        XCTAssertNil(mocks.consentManager.adapter)
    }

    /// Validates that `skippedModuleIDs` drops matching client-side and backend-side modules.
    func testModuleIDsSkipped() throws {
        let clientSideModule1 = ModuleMock(moduleID: "module1")
        let clientSideModule2 = ModuleMock(moduleID: "module2")
        let configuration = SDKConfiguration(
            chartboostAppID: "",
            modules: [clientSideModule1, clientSideModule2],
            skippedModuleIDs: ["no match", clientSideModule1.moduleID, "backend-side-module2"]
        )

        // Initialize
        initializer.initializeSDK(configuration: configuration, moduleObserver: modulesObserver)
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that module initializers were created only for the non-skipped module.
        XCTAssertEqual(mocks.moduleInitializerFactory.makeModuleInitializerCallCount, 1)
        let clientModulesInitialized = mocks.moduleInitializerFactory.makeModuleInitializerModuleAllValues
        let clientModuleInitializers = mocks.moduleInitializerFactory.makeModuleInitializerReturnValues
        XCTAssertEqual(clientModulesInitialized.count, 1)
        XCTAssertEqual(clientModulesInitialized[0].moduleID, "module2")
        XCTAssertEqual(clientModuleInitializers.count, 1)
        XCTAssertEqual(clientModuleInitializers[0].initializeCallCount, 1)

        // Now make the config fetch finish successfully with a few backend-side modules
        mocks.moduleInitializerFactory.reset()  // clear existing records to make next checks easier
        let backendSideModule1 = ModuleMock(moduleID: "backend-side-module1")
        let backendSideModule2 = ModuleMock(moduleID: "backend-side-module2")
        mocks.moduleFactory.makeModuleReturnValues = [backendSideModule1, backendSideModule2]
        let modulesInfo: [AppConfig.ModuleInfo] = [
            .init(className: "someModuleClass1", nonNativeClassName: nil, identifier: "backend-side-module1", credentials: nil),
            .init(className: "someModuleClass2", nonNativeClassName: nil, identifier: "backend-side-module2", credentials: nil),
        ]
        mocks.appConfigRepository.config = .build(modules: modulesInfo)
        mocks.appConfigRepository.fetchAppConfigCompletionLastValue?(nil)
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that module initializers were created only for the non-skipped module.
        XCTAssertEqual(mocks.moduleFactory.makeModuleCallCount, 2)
        XCTAssertEqual(mocks.moduleFactory.makeModuleInfoAllValues, modulesInfo)
        XCTAssertEqual(mocks.moduleInitializerFactory.makeModuleInitializerCallCount, 1)
        let backendModulesInitialized = mocks.moduleInitializerFactory.makeModuleInitializerModuleAllValues
        let backendModuleInitializers = mocks.moduleInitializerFactory.makeModuleInitializerReturnValues
        XCTAssertEqual(backendModulesInitialized.count, 1)
        XCTAssertEqual(backendModulesInitialized[0].moduleID, "backend-side-module1")
        XCTAssertEqual(backendModuleInitializers.count, 1)
        XCTAssertEqual(backendModuleInitializers[0].initializeCallCount, 1)
    }

    /// Validates that different values for Chartboost App ID are ignored after the first successul initialization.
    func testChartboostAppIDCannotBeChangedAfterSuccessfulInit() throws {
        let module1 = ModuleMock(moduleID: "module1")
        let module2 = ModuleMock(moduleID: "module2")
        let configuration = SDKConfiguration(
            chartboostAppID: "appID_1",
            modules: [module1, module2]
        )
        mocks.appConfigRepository.config = .build(chartboostAppID: nil) // no saved chartboost app ID

        // Initialize
        initializer.initializeSDK(configuration: configuration, moduleObserver: modulesObserver)
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that modules are initialized with the first Chartboost App ID
        XCTAssertEqual(mocks.moduleInitializerFactory.makeModuleInitializerCallCount, 2)
        let moduleInitializers = mocks.moduleInitializerFactory.makeModuleInitializerReturnValues
        XCTAssertEqual(moduleInitializers.count, 2)
        XCTAssertEqual(moduleInitializers[0].initializeConfigurationLastValue?.chartboostAppID, "appID_1")
        XCTAssertEqual(moduleInitializers[1].initializeConfigurationLastValue?.chartboostAppID, "appID_1")

        // Now make the config fetch finish successfully
        mocks.appConfigRepository.config = .build(modules: [])
        mocks.appConfigRepository.fetchAppConfigCompletionLastValue?(nil)
        mocks.appConfigRepository.config = .build(chartboostAppID: "appID_1") // save chartboost app ID
        waitForTasksDispatchedOnBackgroundQueue()

        // Now try to initialize again with a different Chartboost App ID
        let module3 = ModuleMock(moduleID: "module3")
        let module4 = ModuleMock(moduleID: "module4")
        let configuration2 = SDKConfiguration(
            chartboostAppID: "appID_2",
            modules: [module3, module4]
        )
        initializer.initializeSDK(configuration: configuration2, moduleObserver: modulesObserver)
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that modules are initialized with the first Chartboost App ID (not the new one!)
        XCTAssertEqual(mocks.moduleInitializerFactory.makeModuleInitializerCallCount, 4)
        let secondBatchOfModuleInitializers = mocks.moduleInitializerFactory.makeModuleInitializerReturnValues
        XCTAssertEqual(secondBatchOfModuleInitializers.count, 4)
        XCTAssertEqual(secondBatchOfModuleInitializers[2].initializeConfigurationLastValue?.chartboostAppID, "appID_1")
        XCTAssertEqual(secondBatchOfModuleInitializers[3].initializeConfigurationLastValue?.chartboostAppID, "appID_1")
    }

    /// Validates that the network status provider starts on init.
    func testInitializeStartsNetworkStatusProvider() {
        // Initialize
        initializer.initializeSDK(configuration: configuration, moduleObserver: modulesObserver)
        waitForTasksDispatchedOnBackgroundQueue()

        XCTAssertEqual(mocks.networkStatusProvider.startNotifierCallCount, 1)
    }
}
