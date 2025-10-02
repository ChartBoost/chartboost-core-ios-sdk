// Copyright 2024-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

// A custom mock that inherits from the auto-generated ConsentManagementPlatformMock, adding conformance to ConsentAdapterProxy.
class ConsentManagementPlatformAdapterProxyMock: ConsentManagementPlatformMock, ConsentAdapterProxy {
    var adapter: ConsentAdapter?
}
