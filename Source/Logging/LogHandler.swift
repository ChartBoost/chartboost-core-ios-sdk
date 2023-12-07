// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// The protocol for custom log handlers for the unified logging subsystem.
///
/// Conformers to this protocol are added to the logging system using the ``ChartboostCore/attachLogHandler(_:)`` method.
@objc(CBCLogHandler)
public protocol LogHandler: AnyObject {
    /// Called on every handler previously registered with ``ChartboostCore/attachLogHandler(_:)`` to handle `entry`.
    func handle(_ entry: LogEntry)
}
