// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A unified logging subystem which receives and forwards logs to handlers that can be attached to it.
@objc(CBCLogger)
@objcMembers
public final class Logger: NSObject {
    /// The logger subsystem, based on the identifiers of all its ancestors.
    public let subsystem: String

    /// A user-friendly name that indicates what kind of logs this logger is intended to handle.
    public let name: String

    /// The logger's parent.
    /// Loggers forward logs to their parent, recursively, so they get processed by their handlers too.
    private let parent: Logger?

    /// List of attached handlers that process the logs received.
    @Atomic private var handlers: [LogHandler] = []

    /// The root logger.
    /// Other loggers may use this as their parent (the default) so their logs get forwarded to its handlers.
    /// It should not be used to post logs directly.
    static let root = Logger(id: "", name: "Root", parent: nil, defaultToRootLogger: false)

    /// Instantiates a logger.
    /// - parameter id: The logger ID.
    /// - parameter name The logger name.
    /// - parameter parent: The logger parent. If nil is provided the root logger is used.
    public convenience init(id: String, name: String, parent: Logger? = nil) {
        self.init(id: id, name: name, parent: parent, defaultToRootLogger: true)
    }

    init(id: String, name: String, parent: Logger?, defaultToRootLogger: Bool) {
        let parent = parent ?? (defaultToRootLogger ? Self.root : nil)
        let subsystemPrefix = parent?.subsystem ?? ""
        self.subsystem = (subsystemPrefix.isEmpty ? "" : subsystemPrefix + ".") + id
        self.name = name
        self.parent = parent
    }

    @available(*, unavailable)
    override init() {
        fatalError("init() has not been implemented")
    }

    /// Attach a custom logger handler to the logger.
    /// - Parameter handler: A custom class that conforms to the `LogHandler` protocol.
    public func attachHandler(_ handler: LogHandler) {
        $handlers.mutate { handlers in
            guard !handlers.contains(where: { handler === $0 }) else {
                return
            }
            handlers.append(handler)
        }
    }

    /// Detach a custom logger handler from the logging system.
    /// - Parameter handler: A custom class that conforms to the `LogHandler` protocol.
    public func detachHandler(_ handler: LogHandler) {
        $handlers.mutate { handlers in
            handlers.removeAll(where: { handler === $0 })
        }
    }

    /// Log a message at log severity level `trace`.
    /// - Parameter message: The logged message.
    public func verbose(_ message: String) {
        log(message, level: .verbose)
    }

    /// Log a message at log severity level `debug`.
    /// - Parameter message: The logged message.
    public func debug(_ message: String) {
        log(message, level: .debug)
    }

    /// Log a message at log severity level `info`.
    /// - Parameter message: The logged message.
    public func info(_ message: String) {
        log(message, level: .info)
    }

    /// Log a message at log severity level `warning`.
    /// - Parameter message: The logged message.
    public func warning(_ message: String) {
        log(message, level: .warning)
    }

    /// Log a message at log severity level `error`.
    /// - Parameter message: The logged message.
    public func error(_ message: String) {
        log(message, level: .error)
    }

    /// Log a message at the indicated severty level.
    /// - Parameter message: The logged message.
    /// - Parameter level: The severity level.
    public func log(_ message: String, level: LogLevel) {
        let entry = LogEntry(message: message, subsystem: subsystem, category: name, logLevel: level)
        // Forward the log entry to the logger handlers and its parent's handlers, recursively
        var logger: Logger? = self
        while let evaluatedLogger = logger {
            evaluatedLogger.$handlers.mutate { handlers in
                handlers.forEach {
                    $0.handle(entry)
                }
            }
            logger = evaluatedLogger.parent
        }
    }
}
