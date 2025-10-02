// Copyright 2018-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

/// A custom log handler that handles log level overrides from backend.
class CoreConsoleLogHandler: ConsoleLogHandler {
    @Injected(\.appConfig) private var appConfig

    @Atomic private var clientSideLogLevel: LogLevel = .info

    // This is the logLevel property used by the superclass.
    override var logLevel: LogLevel {
        get {
            // If the backend has overridden the local setting, always use that that log level.
            return appConfig.logLevelOverride ?? clientSideLogLevel
        }
        set {
            clientSideLogLevel = newValue
        }
    }
}
