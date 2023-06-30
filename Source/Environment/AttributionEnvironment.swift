// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

@objc(ChartboostCoreAttributionEnvironment)
public protocol AttributionEnvironment {
    var advertisingID: String? { get }
    var userAgent: String? { get }
}
