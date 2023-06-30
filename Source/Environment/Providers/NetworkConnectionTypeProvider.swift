// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import CoreTelephony
import Foundation

protocol NetworkConnectionTypeProvider {
    var connectionType: NetworkConnectionType { get }
}

struct ChartboostCoreNetworkConnectionTypeProvider: NetworkConnectionTypeProvider {

    /// This is `static` to make sure it's only instantiated once, since this class may cause crashes
    /// if deallocated due to a known Apple bug.
    private static let networkInfo = CTTelephonyNetworkInfo()

    @Injected(\.networkStatusProvider) private var networkStatusProvider

    var connectionType: NetworkConnectionType {
        switch networkStatusProvider.status {
        case .unknown, .notReachable:
            return .unknown

        case .reachableViaWiFi:
            return .wifi

        case .reachableViaWWAN:
            // https://developer.apple.com/documentation/coretelephony/cttelephonynetworkinfo/radio_access_technology_constants
            let currentRadioAccessTechnology = Self.networkInfo.currentRadioAccessTechnology

            switch currentRadioAccessTechnology {
            case CTRadioAccessTechnologyLTE:
                return .cellular4G

            case CTRadioAccessTechnologyCDMAEVDORev0,
                 CTRadioAccessTechnologyCDMAEVDORevA,
                 CTRadioAccessTechnologyCDMAEVDORevB,
                 CTRadioAccessTechnologyeHRPD,
                 CTRadioAccessTechnologyHSDPA,
                 CTRadioAccessTechnologyHSUPA,
                 CTRadioAccessTechnologyWCDMA:
                return .cellular3G

            case CTRadioAccessTechnologyCDMA1x,
                 CTRadioAccessTechnologyEdge,
                 CTRadioAccessTechnologyGPRS:
                return .cellular2G

            default:
                if #available(iOS 14.1, *) {
                    if currentRadioAccessTechnology == CTRadioAccessTechnologyNR ||
                       currentRadioAccessTechnology == CTRadioAccessTechnologyNRNSA {
                        return .cellular5G
                    }
                }
                return .unknown
            }
        }
    }
}
