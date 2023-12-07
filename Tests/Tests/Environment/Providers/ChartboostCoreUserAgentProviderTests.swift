// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ChartboostCoreUserAgentProviderTests: ChartboostCoreTestCase {

    let provider = ChartboostCoreUserAgentProvider()

    /// Validates that calling `updateUserAgent()` fetches a new user agent.
    func testUpdateUserAgent() {
        let expectation = expectation(description: "wait for fetch user agent")

        provider.userAgent { userAgent in
            guard let userAgent else {
                XCTFail("`userAgent is nil")
                return
            }
            XCTAssert(!userAgent.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    /// Validates nothing goes wrong after calling `updateUserAgent()` multiple times in different scenarios.
    func testMultipleUpdateUserAgentCalls() {
        let expectation1 = expectation(description: "wait for fetch user agent 1")
        let expectation2 = expectation(description: "wait for fetch user agent 2")
        let expectation3 = expectation(description: "wait for fetch user agent 3")
        let expectation4 = expectation(description: "wait for fetch user agent 4")

        // nested calls
        provider.userAgent { [self] userAgent in
            guard let userAgent else {
                XCTFail("`userAgent is nil")
                return
            }

            XCTAssert(!userAgent.isEmpty)

            provider.userAgent { userAgent in
                guard let userAgent else {
                    XCTFail("`userAgent is nil")
                    return
                }

                XCTAssert(!userAgent.isEmpty)
                expectation1.fulfill()
            }
        }

        // nested calls again
        provider.userAgent { [self] userAgent in
            guard let userAgent else {
                XCTFail("`userAgent is nil")
                return
            }

            XCTAssert(!userAgent.isEmpty)

            provider.userAgent { userAgent in
                guard let userAgent else {
                    XCTFail("`userAgent is nil")
                    return
                }

                XCTAssert(!userAgent.isEmpty)
                expectation2.fulfill()
            }
        }

        // nested calls again in main thread
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            provider.userAgent { [self] userAgent in
                guard let userAgent else {
                    XCTFail("`userAgent is nil")
                    return
                }

                XCTAssert(!userAgent.isEmpty)

                provider.userAgent { userAgent in
                    guard let userAgent else {
                        XCTFail("`userAgent is nil")
                        return
                    }

                    XCTAssert(!userAgent.isEmpty)
                    expectation3.fulfill()
                }
            }
        }

        // nested calls again in background thread
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) { [self] in
            provider.userAgent { [self] userAgent in
                guard let userAgent else {
                    XCTFail("`userAgent is nil")
                    return
                }

                XCTAssert(!userAgent.isEmpty)

                provider.userAgent { userAgent in
                    guard let userAgent else {
                        XCTFail("`userAgent is nil")
                        return
                    }

                    XCTAssert(!userAgent.isEmpty)
                    expectation4.fulfill()
                }
            }
        }

        wait(for: [expectation1, expectation2, expectation3, expectation4], timeout: 10)
    }
}
