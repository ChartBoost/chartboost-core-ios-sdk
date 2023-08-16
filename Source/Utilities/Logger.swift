// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.


import Foundation
import os.log

/// The shared logger instance.
let logger = Logger(subsystem: "com.chartboost.core", category: "Chartboost Core")

/// A logger component that can log messages to the console with different severity levels.
final class Logger {

    private let queue = DispatchQueue(label: "com.chartboost.core.logger")

    private let log: OSLog

    private let category: String

    private lazy var dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.formatOptions = [.withFullDate, .withFullTime, .withSpaceBetweenDateAndTime]
        return formatter
    }()

    /// The desired log level.
    /// For now it can't be changed. We might add a public method to change its value in the future.
    private let logLevel: LogLevel = .trace

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
        guard logLevel <= level  else {
            return
        }
        if #available(iOS 12, *) {
            osLog(message, level: level)
        } else {
            print(message)
        }
    }

    /// Instantiates a new logger with the indicated OSLog subsystem and category.
    init(subsystem: String, category: String) {
        self.log = OSLog(subsystem: subsystem, category: category)
        self.category = category
    }

    // MARK: - Private

    @available(iOS 12, *)
    private func osLog(_ message: String, level: LogLevel) {
        guard let type = level.asOSLogType else {
            return
        }
        os_log(type, log: log, "%{public}s", message)
    }

    private func print(_ message: String) {
        let timestamp = dateFormatter.string(from: Date())
        Swift.print("\(timestamp)", "[\(category)]", message)
    }
}

private extension LogLevel {
    /// Maps `LogLevel` to an appropriate `OSLogType`.
    var asOSLogType: OSLogType? {
        switch self {
        case .none:
            return nil
        case .trace, .debug:
            // Use this level to capture information that may be useful during development or while
            // troubleshooting a specific problem.
            return .debug
        case .info:
            // Use this level to capture information that may be helpful, but not essential, for
            // troubleshooting errors.
            return .info
        case .warning:
            // Use this level to capture information about things that might result in a failure.
            return .default
        case .error:
            // Use this log level to report process-level errors.
            return .error
        }
    }
}
