// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ChartboostCoreAppConfigRepositoryTests: ChartboostCoreTestCase {

    let repository = ChartboostCoreAppConfigRepository()

    /// Validates that the initial config has proper default values.
    func testDefaultConfig() {
        XCTAssertEqual(
            repository.config,
            AppConfig(
                coreInitializationDelayBase: 1,
                coreInitializationDelayMax: 30,
                coreInitializationRetryCountMax: 3,
                moduleInitializationDelayBase: 1,
                moduleInitializationDelayMax: 30,
                moduleInitializationRetryCountMax: 3,
                isChildDirected: nil,
                modules: []
            )
        )
    }

    /// Validates that a call to `fetchAppConfig()` fetches a new config from backend before completing
    /// when no config is cached.
    func testFetchAppConfigWhenNoConfigIsCached() {
        let expectation = self.expectation(description: "wait for fetch completion")

        // Start the fetch
        let configuration = SDKConfiguration(chartboostAppID: "some app id")
        repository.fetchAppConfig(with: configuration) { error in
            // Check that fetch is successful
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that the network request was sent with the proper info from the request factory
        XCTAssertEqual(mocks.appConfigRequestFactory.makeRequestCallCount, 1)
        XCTAssertIdentical(mocks.appConfigRequestFactory.makeRequestConfigurationLastValue, configuration)
        XCTAssertIdentical(mocks.appConfigRequestFactory.makeRequestEnvironmentLastValue, mocks.environment)
        XCTAssertEqual(mocks.networkManager.sendCallCount, 1)
        XCTAssertEqual(mocks.networkManager.sendRequestLastValue as? AppConfigRequest, mocks.appConfigRequestFactory.makeRequestReturnValue)

        // Finish the network request successfully
        let response = AppConfigRequest.ResponseBody.build()
        (mocks.networkManager.sendCompletionLastValue as? (HTTPResponse<AppConfigRequest.ResponseBody>) -> Void)?(
            HTTPResponse(statusCode: 200, headers: nil, result: .success(response))
        )

        // The fetchAppConfig() completion should be executed at this point
        waitForExpectations(timeout: 5)

        // Check that the config was updated using the info provided by the factory
        XCTAssertEqual(mocks.appConfigFactory.makeAppConfigCallCount, 1)
        XCTAssertEqual(mocks.appConfigFactory.makeAppConfigResponseLastValue, response)
        XCTAssertEqual(repository.config, mocks.appConfigFactory.makeAppConfigReturnValue)

        // Check that new config was persisted
        XCTAssertEqual(mocks.jsonRepository.writeCallCount, 1)
        XCTAssertEqual(mocks.jsonRepository.writeValueLastValue as? AppConfig, mocks.appConfigFactory.makeAppConfigReturnValue)
        XCTAssertEqual(mocks.jsonRepository.writeNameLastValue, "config")
    }

    /// Validates that a call to `fetchAppConfig()` reports an error if the network manager fails to retrieve
    /// a backend config response.
    func testFetchAppConfigFailsWhenNetworkManagerFails() {
        let expectedError = NSError(domain: "some domain", code: 12345)
        let expectation = self.expectation(description: "wait for fetch completion")

        // Start the fetch
        let configuration = SDKConfiguration(chartboostAppID: "some app id")
        repository.fetchAppConfig(with: configuration) { error in
            // Check that fetch is failure
            XCTAssertIdentical(error as? NSError, expectedError)
            expectation.fulfill()
        }
        waitForTasksDispatchedOnBackgroundQueue()

        // Finish the network request with a failure
        (mocks.networkManager.sendCompletionLastValue as? (HTTPResponse<AppConfigRequest.ResponseBody>) -> Void)?(
            HTTPResponse(statusCode: 400, headers: nil, result: .failure(expectedError))
        )

        // The fetchAppConfig() completion should be executed at this point
        waitForExpectations(timeout: 5)

        // Check that the config value remains the default
        testDefaultConfig()
    }

    /// Validates that a call to `fetchAppConfig()` reports an error if the network manager fails to retrieve
    /// a valid backend config response.
    func testFetchAppConfigFailsWhenNetworkResponseIsInvalid() {
        let expectation = self.expectation(description: "wait for fetch completion")

        // Start the fetch
        let configuration = SDKConfiguration(chartboostAppID: "some app id")
        repository.fetchAppConfig(with: configuration) { error in
            // Check that fetch is failure
            XCTAssertEqual(error as? ChartboostCoreAppConfigRepository.FetchAppConfigError, .receivedNilResponseBody)
            expectation.fulfill()
        }
        waitForTasksDispatchedOnBackgroundQueue()

        // Finish the network request with success but a nil response body
        (mocks.networkManager.sendCompletionLastValue as? (HTTPResponse<AppConfigRequest.ResponseBody>) -> Void)?(
            HTTPResponse(statusCode: 400, headers: nil, result: .success(nil))
        )

        // The fetchAppConfig() completion should be executed at this point
        waitForExpectations(timeout: 5)

        // Check that the config value remains the default
        testDefaultConfig()
    }

    /// Validates that a call to `fetchAppConfig()` succeeds immediately if a config is already cached.
    func testFetchAppConfigWhenConfigIsAlreadyCached() {
        // First fetch a config from backend
        testFetchAppConfigWhenNoConfigIsCached()
        // Clean up mock info to make next validations easier
        mocks.appConfigRequestFactory.makeRequestCallCount = 0
        mocks.networkManager.sendCallCount = 0
        mocks.appConfigFactory.makeAppConfigCallCount = 0
        mocks.jsonRepository.writeCallCount = 0
        mocks.appConfigFactory.makeAppConfigReturnValue = .build(coreInitializationDelayBase: 23.34, coreInitializationRetryCountMax: 1234)

        let expectation = self.expectation(description: "wait for fetch completion")

        // Start the fetch
        let configuration = SDKConfiguration(chartboostAppID: "some app id")
        repository.fetchAppConfig(with: configuration) { error in
            // Check that fetch is successful
            XCTAssertNil(error)
            expectation.fulfill()
        }
        // The fetchAppConfig() completion should be executed immediately
        waitForExpectations(timeout: 5)

        // Check that the network request was sent in the background
        XCTAssertEqual(mocks.appConfigRequestFactory.makeRequestCallCount, 1)
        XCTAssertEqual(mocks.networkManager.sendCallCount, 1)

        // Finish the network request successfully with a new response
        let response = AppConfigRequest.ResponseBody.build(coreInitializationDelayBaseMs: 23, moduleInitializationDelayBaseMs: 434)
        (mocks.networkManager.sendCompletionLastValue as? (HTTPResponse<AppConfigRequest.ResponseBody>) -> Void)?(
            HTTPResponse(statusCode: 200, headers: nil, result: .success(response))
        )
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that the config was updated using the new info provided by the factory
        XCTAssertEqual(mocks.appConfigFactory.makeAppConfigCallCount, 1)
        XCTAssertEqual(mocks.appConfigFactory.makeAppConfigResponseLastValue, response)
        XCTAssertEqual(repository.config, mocks.appConfigFactory.makeAppConfigReturnValue)

        // Check that new config was persisted
        XCTAssertEqual(mocks.jsonRepository.writeCallCount, 1)
        XCTAssertEqual(mocks.jsonRepository.writeValueLastValue as? AppConfig, mocks.appConfigFactory.makeAppConfigReturnValue)
    }

    /// Validates that a call to `fetchAppConfig()` succeeds immediately if a persisted config can be retrieved.
    func testFetchAppConfigWhenConfigIsPersisted() {
        let persistedAppConfig = AppConfig.build()
        mocks.jsonRepository.valueExistsReturnValue = true
        mocks.jsonRepository.readReturnValue = persistedAppConfig

        let expectation = self.expectation(description: "wait for fetch completion")

        // Start the fetch
        let configuration = SDKConfiguration(chartboostAppID: "some app id")
        repository.fetchAppConfig(with: configuration) { error in
            // Check that fetch is successful
            XCTAssertNil(error)
            expectation.fulfill()
        }
        // The fetchAppConfig() completion should be executed immediately
        waitForExpectations(timeout: 5)

        // Check that the network request was sent in the background
        XCTAssertEqual(mocks.appConfigRequestFactory.makeRequestCallCount, 1)
        XCTAssertEqual(mocks.networkManager.sendCallCount, 1)

        // Finish the network request successfully with a new response
        let response = AppConfigRequest.ResponseBody.build(coreInitializationDelayBaseMs: 23, moduleInitializationDelayBaseMs: 434)
        (mocks.networkManager.sendCompletionLastValue as? (HTTPResponse<AppConfigRequest.ResponseBody>) -> Void)?(
            HTTPResponse(statusCode: 200, headers: nil, result: .success(response))
        )
        waitForTasksDispatchedOnBackgroundQueue()

        // Check that the config was updated using the new info provided by the factory
        XCTAssertEqual(mocks.appConfigFactory.makeAppConfigCallCount, 1)
        XCTAssertEqual(mocks.appConfigFactory.makeAppConfigResponseLastValue, response)
        XCTAssertEqual(repository.config, mocks.appConfigFactory.makeAppConfigReturnValue)

        // Check that new config was persisted
        XCTAssertEqual(mocks.jsonRepository.writeCallCount, 1)
        XCTAssertEqual(mocks.jsonRepository.writeValueLastValue as? AppConfig, mocks.appConfigFactory.makeAppConfigReturnValue)
    }

    /// Validates that a call to `fetchAppConfig()` fetches a new config from backend before completing
    /// when an invalid config is persisted.
    func testFetchAppConfigWhenConfigIsPersistedButItIsInvalid() {
        mocks.jsonRepository.valueExistsReturnValue = true
        mocks.jsonRepository.readReturnValue = NSError(domain: "parsing error", code: 3)

        // Expect same behavior as in the case where no config was cached
        testFetchAppConfigWhenNoConfigIsCached()

        // Check that the invalid config file was removed
        XCTAssertEqual(mocks.jsonRepository.removeValueCallCount, 1)
        XCTAssertEqual(mocks.jsonRepository.removeValueNameLastValue, "config")
    }
}
