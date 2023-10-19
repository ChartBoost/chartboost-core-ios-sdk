// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Log severity levels for the unified logging subsystem.
@objc(CBCLogLevel)
public enum LogLevel: Int, CustomStringConvertible {

    /// Log very low level and/or noisy information that may be useful during development or troubleshooting.
    case trace

    /// Log information that may be useful during development or troubleshooting.
    case debug

    /// Log helpful, non-essential information.
    case info

    /// Log information that may result in a failure.
    case warning

    /// Log information that communicates an error.
    case error
    
    /// No logging is expected to be performed.
    case none

    /// The string representation of the log level.
    public var description: String {
        switch self {
        case .trace: return "trace"
        case .debug: return "debug"
        case .info: return "info"
        case .warning: return "warning"
        case .error: return "error"
        case .none: return "none"
        }
    }
}

extension LogLevel: Comparable {
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
