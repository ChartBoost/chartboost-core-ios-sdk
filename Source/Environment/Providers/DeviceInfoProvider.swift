// Copyright 2023-2024 Chartboost, Inc.
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
    var screenHeightPixels: Double { get }

    /// The screen scale.
    var screenScale: Double { get }

    /// The width of the screen in pixels.
    var screenWidthPixels: Double { get }

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
        var size: Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var deviceModel = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &deviceModel, &size, nil, 0)
        return deviceModel.isEmpty ? UIDevice.current.model : String(cString: deviceModel)
    }

    var osName: String {
        UIDevice.current.systemName
    }

    var osVersion: String {
        UIDevice.current.systemVersion
    }

    var screenHeightPixels: Double {
        mainScreen.bounds.size.height * screenScale
    }

    var screenScale: Double {
        Double(mainScreen.scale)
    }

    var screenWidthPixels: Double {
        mainScreen.bounds.size.width * screenScale
    }

    var volume: Double {
        Double(AVAudioSession.sharedInstance().outputVolume)
    }

    private var mainScreen: UIScreen {
        // `UIScreen.main` was deprecated in iOS 16. Apple doc:
        //   https://developer.apple.com/documentation/uikit/uiscreen/1617815-main
        // Since `UIScreen.main` has been working correctly at least up to iOS 16, the custom
        // implementation only targets iOS 17+, not iOS 13+.
        if #available(iOS 17.0, *) {
            return screenOfFirstConnectedWindowScene
        } else {
            return .main
        }
    }

    /// This is a best-effort approach for obtaining the main screen of an app.
    /// Modern iOS supports multi-window scenarios on iPad, as well as newer technologies such as
    /// CarPlay which uses `CPTemplateApplicationScene` + `CPWindow` instead of `UIWindowScene` +
    /// `UIWindow`. Apple may remove the `UIScreen.main` API completely in the future, but we can
    /// use it as the fallback until then.
    /// Note: `UIApplication.connectedScenes` must be used from main thread only, so does this helper.
    private var screenOfFirstConnectedWindowScene: UIScreen {
        var screen: UIScreen {
            let windowScenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            let prioritizedActivationStates: [UIScene.ActivationState] = [
                .foregroundActive, // one and only one `foregroundActive` scene is expected
                .foregroundInactive,
                .background,
                .unattached,
            ]
            for activationState in prioritizedActivationStates {
                if let scene = windowScenes.first(where: { $0.activationState == activationState }) {
                    return scene.screen
                }
            }
            return .main
        }

        if Thread.isMainThread {
            return screen
        } else {
            return DispatchQueue.main.sync { screen }
        }
    }
}
