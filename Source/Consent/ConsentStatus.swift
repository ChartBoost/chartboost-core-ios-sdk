// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

@objc(ChartboostCoreConsentStatus)
public enum ConsentStatus: Int {
    case unknown = -1
    case denied
    case granted
}
