// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// The shared logger instance.
let logger = Logger(subsystem: "com.chartboost.core.sdk", category: "Chartboost Core")

/// A unified logging subystem which receives and forwards logs to handlers that can be attached to it.
/// The console log handler is attached by default.
final class Logger {

    private let queue = DispatchQueue(label: "com.chartboost.core.logger")

    private let category: String

    private let subsystem: String

    private lazy var dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.formatOptions = [.withFullDate, .withFullTime, .withSpaceBetweenDateAndTime]
        return formatter
    }()

    @Atomic private static var handlers: [LogHandler] = [consoleLogHandler]

    static let consoleLogHandler = ConsoleLogHandler()

    /// Attach a custom logger handler to the logging system. The console handler is attached by default.
    /// - Parameter handler: A custom class that conforms to the `LogHandler` protocol.
    static func attachHandler(_ handler: LogHandler) {
        $handlers.mutate { handlers in
            guard !handlers.contains(where: { handler === $0 }) else {
                return
            }
            handlers.append(handler)
        }
    }

    /// Detach a custom logger handler from the logging system.
    /// - Parameter handler: A custom class that conforms to the `LogHandler` protocol.
    static func detachHandler(_ handler: LogHandler) {
        $handlers.mutate { handlers in
            handlers.removeAll(where: { handler === $0 })
        }
    }

    /// Log a message at log severity level `trace`.
    /// - Parameter message: The logged message.
    func trace(_ message: String) {
        log(message, level: .trace)
    }

    /// Log a message at log severity level `debug`.
    /// - Parameter message: The logged message.
    func debug(_ message: String) {
        log(message, level: .debug)
    }

    /// Log a message at log severity level `info`.
    /// - Parameter message: The logged message.
    func info(_ message: String) {
        log(message, level: .info)
    }

    /// Log a message at log severity level `warning`.
    /// - Parameter message: The logged message.
    func warning(_ message: String) {
        log(message, level: .warning)
    }

    /// Log a message at log severity level `error`.
    /// - Parameter message: The logged message.
    func error(_ message: String) {
        log(message, level: .error)
    }

    /// Log a message at the indicated severty level.
    /// - Parameter message: The logged message.
    /// - Parameter level: The severity level.
    func log(_ message: String, level: LogLevel) {
        let entry = LogEntry(message: message, subsystem: subsystem, category: category, logLevel: level)
        Self.$handlers.mutate { handlers in
            handlers.forEach { handler in
                queue.async {
                    handler.handle(entry)
                }
            }
        }
    }

    /// Instantiates a new logger with the indicated OSLog subsystem and category.
    init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
    }
}
