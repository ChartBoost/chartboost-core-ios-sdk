// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import AVFoundation

protocol DeviceInfoProvider {
    var deviceLocale: String? { get }
    var make: String { get }
    var model: String { get }
    var osName: String { get }
    var osVersion: String { get }
    var screenHeight: Double { get }
    var screenScale: Double { get }
    var screenWidth: Double { get }
    var volume: Double { get }
}

final class ChartboostCoreDeviceInfoProvider: DeviceInfoProvider {

    var deviceLocale: String? {
        Locale.current.identifier
    }

    var make: String {
        "Apple"
    }

    var model: String {
        var size : Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var deviceModel = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &deviceModel, &size, nil, 0)
        return deviceModel.count > 0 ? String(cString: deviceModel) : UIDevice.current.model
    }

    var osName: String {
        UIDevice.current.systemName
    }

    var osVersion: String {
        UIDevice.current.systemVersion
    }

    var screenHeight: Double {
        UIScreen.main.bounds.size.height * screenScale
    }

    var screenScale: Double {
        Double(UIScreen.main.scale)
    }

    var screenWidth: Double {
        UIScreen.main.bounds.size.width * screenScale
    }

    var volume: Double {
        Double(AVAudioSession.sharedInstance().outputVolume)
    }
}

