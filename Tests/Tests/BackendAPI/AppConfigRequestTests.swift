// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class AppConfigRequestTests: ChartboostCoreTestCase {

    /// Validates that the config request can be encoded and the JSON output is as expected.
    func testRequestEncodingToJSON() throws {
        // Create request
        let request = AppConfigRequest(body: .init(
                configuration: .init(
                    app: .init(
                        bundleId: "some bundle id",
                        publisherApplicationIdentifier: "some pub app id",
                        version: "some app version"
                    ),
                    chartboostApplicationIdentifier: "some cb app id",
                    coreVersion: "some core version",
                    framework: .init(
                        name: "some framework name",
                        version: "some framework version"
                    ),
                    player: .init(
                        playerId: "some player id"
                    ),
                    schemaVersion: "some schema version",
                    vendor: .init(
                        identifier: "some vendor id",
                        scope: "some scope id"
                    )
                ),
                device: .init(
                    locale: "some locale",
                    network: .init(
                        connectionType: "some connection type"
                    ),
                    os: .init(
                        name: "some os name",
                        version: "some os version"
                    ),
                    screen: .init(
                        height: 42,
                        width: 64,
                        scale: 2.5
                    ),
                    specifications: .init(
                        make: "some make",
                        model: "some model"
                    )
                )
        ))

        // Define the expected JSON output
        let expectedJSONString = """
{
  "configuration" : {
    "app" : {
      "bundleId" : "some bundle id",
      "publisherApplicationIdentifier" : "some pub app id",
      "version" : "some app version"
    },
    "chartboostApplicationIdentifier" : "some cb app id",
    "coreVersion" : "some core version",
    "framework" : {
      "name" : "some framework name",
      "version" : "some framework version"
    },
    "player" : {
      "playerId" : "some player id"
    },
    "schemaVersion" : "some schema version",
    "vendor" : {
      "identifier" : "some vendor id",
      "scope" : "some scope id"
    }
  },
  "device" : {
    "locale" : "some locale",
    "network" : {
      "connectionType" : "some connection type"
    },
    "os" : {
      "name" : "some os name",
      "version" : "some os version"
    },
    "screen" : {
      "height" : 42,
      "scale" : 2.5,
      "width" : 64
    },
    "specifications" : {
      "make" : "some make",
      "model" : "some model"
    }
  }
}
"""

        // Encode it
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let jsonData = try encoder.encode(request.body)
        let jsonString = String(data: jsonData, encoding: .utf8)

        // Check that it has the expected value
        XCTAssertEqual(jsonString, expectedJSONString )
    }

    /// Validates that the config response can be decoded from a JSON string as expected.
    func testResponseDecodingFromJSON() throws {
        // Define a full JSON response
        let jsonResponse = """
{
  "coreInitializationDelayBaseMs" : 20,
  "isChildDirected" : true,
  "coreInitializationDelayMaxMs" : 320,
  "coreInitializationRetryCountMax" : 4,
  "moduleInitializationDelayMaxMs" : 93,
  "moduleInitializationRetryCountMax" : 77,
  "moduleInitializationDelayBaseMs" : 322,
  "modules" : [
    {
      "className" : "module 1 name",
      "config" : {
        "params" : {
          "param1:" : "value1",
          "param2" : 23

        },
        "version" : "module 1 version"

      },
      "id" : "module 1 id"

    },
    {
      "className" : "module 2 name",
      "config" : {
        "params" : {
          "param3:" : "value3",
          "param4" : 42

        },
        "version" : "module 2 version"

      },
      "id" : "module 2 id"

    }
  ],
  "schemaVersion" : "some schema version"
}
"""

        // Define the expected response model
        let expectedResponseModel = AppConfigRequest.ResponseBody(
            isChildDirected: true,
            coreInitializationDelayBaseMs: 20,
            coreInitializationDelayMaxMs: 320,
            coreInitializationRetryCountMax: 4,
            moduleInitializationDelayBaseMs: 322,
            moduleInitializationDelayMaxMs: 93,
            moduleInitializationRetryCountMax: 77,
            schemaVersion: "some schema version",
            modules: [
                .init(
                    className: "module 1 name",
                    config: .init(
                        version: "module 1 version",
                        params: .init(value: ["param1:": "value1", "param2": 23])
                    ),
                    id: "module 1 id"
                ),
                .init(
                    className: "module 2 name",
                    config: .init(
                        version: "module 2 version",
                        params: .init(value: ["param3:": "value3", "param4": 42])
                    ),
                    id: "module 2 id"
                )
        ])

        // Decode the response model from the string
        let jsonData = try XCTUnwrap(jsonResponse.data(using: .utf8))
        let decoder = JSONDecoder()
        let decodedModel = try decoder.decode(AppConfigRequest.ResponseBody.self, from: jsonData)

        // Check that the generated model has the expected properties
        XCTAssertEqual(decodedModel, expectedResponseModel)
    }

    /// Validates that the config response can be decoded from an empty JSON string.
    /// This makes sure that our backend can easily disable the app config service.
    func testResponseDecodingFromEmptyJSON() throws {
        // Define an empty JSON response
        let jsonResponse = "{}"

        // Define the expected response model
        let expectedResponseModel = AppConfigRequest.ResponseBody(
            isChildDirected: nil,
            coreInitializationDelayBaseMs: nil,
            coreInitializationDelayMaxMs: nil,
            coreInitializationRetryCountMax: nil,
            moduleInitializationDelayBaseMs: nil,
            moduleInitializationDelayMaxMs: nil,
            moduleInitializationRetryCountMax: nil,
            schemaVersion: nil,
            modules: nil
        )
        // Decode the response model from the string
        let jsonData = try XCTUnwrap(jsonResponse.data(using: .utf8))
        let decoder = JSONDecoder()
        let decodedModel = try decoder.decode(AppConfigRequest.ResponseBody.self, from: jsonData)

        // Check that the generated model has the expected properties
        XCTAssertEqual(decodedModel, expectedResponseModel)
    }
}
