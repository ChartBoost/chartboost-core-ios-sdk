// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

enum NetworkStatus: Int {
    case unknown = -1
    case notReachable = 0
    case reachableViaWiFi = 1
    case reachableViaWWAN = 2
}
