// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import AVFoundation

/// Provides information related to the device.
protocol DeviceInfoProvider {

    /// The device locale string, e.g. "en-US".
    var deviceLocale: String? { get }

    /// The device make, e.g. "Apple".
    var make: String { get }

    /// The device model, e.g. "iPhone11,2".
    var model: String { get }

    /// The OS name, e.g. "iOS" or "iPadOS".
    var osName: String { get }

    /// The OS version, e.g. "17.0".
    var osVersion: String { get }

    /// The height of the screen in pixels.
    var screenHeight: Double { get }

    /// The screen scale.
    var screenScale: Double { get }

    /// The width of the screen in pixels.
    var screenWidth: Double { get }

    /// The device volume level.
    var volume: Double { get }
}

/// Core's concrete implementation of ``DeviceInfoProvider``.
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

