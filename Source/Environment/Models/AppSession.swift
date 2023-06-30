// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

struct AppSession {
    let identifier = UUID().uuidString
    let startDate = Date()

    var duration: TimeInterval {
        abs(startDate.timeIntervalSinceNow)
    }
}
