// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

@objc(ChartboostCoreNetworkConnectionType)
public enum NetworkConnectionType: Int {
    case unknown
    case wired
    case wifi
    case cellularUnknown
    case cellular2G
    case cellular3G
    case cellular4G
    case cellular5G
}
