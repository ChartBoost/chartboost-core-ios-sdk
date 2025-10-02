// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Log severity levels for the unified logging subsystem.
@objc(CBCLogLevel)
public enum LogLevel: Int, Codable, CustomStringConvertible {
    /// No logging is expected to be performed.
    case disabled

    /// Log information that communicates an error.
    case error

    /// Log information that may result in a failure.
    case warning

    /// Log helpful, non-essential information.
    case info

    /// Log information that may be useful during development or troubleshooting.
    case debug

    /// Log very low level and/or noisy information that may be useful during development or troubleshooting.
    case verbose

    /// The string representation of the log level.
    public var description: String {
        switch self {
        case .verbose: return "verbose"
        case .debug: return "debug"
        case .info: return "info"
        case .warning: return "warning"
        case .error: return "error"
        case .disabled: return "disabled"
        }
    }

    public init?(string: String) {
        switch string.lowercased() {
        case "verbose":
            self = .verbose
        case "debug":
            self = .debug
        case "info":
            self = .info
        case "warning":
            self = .warning
        case "error":
            self = .error
        case "disabled":
            self = .disabled
        default:
            return nil
        }
    }
}

extension LogLevel: Comparable {
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
