// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Application session model.
struct AppSession {
    /// The session's identifier.
    let identifier = UUID().uuidString

    /// The session's start date.
    let startDate = Date()

    /// The session's duration.
    var duration: TimeInterval {
        abs(startDate.timeIntervalSinceNow)
    }
}
