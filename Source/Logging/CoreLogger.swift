// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

extension ConsoleLogHandler {
    /// The internal console log handler for the Core SDK.
    static let core = CoreConsoleLogHandler()
}

extension Logger {
    /// The internal logger for the Core SDK.
    static var core: Logger { logger }
}

/// The internal logger for the Core SDK, as a global instance for convenience.
let logger: Logger = {
    let logger = Logger(
        id: "com.chartboost.core",
        name: "Chartboost Core"
    )
    logger.attachHandler(ConsoleLogHandler.core)
    return logger
}()
