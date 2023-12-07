// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

@objc
extension NSNotification {
    /// The associated `object` is a `LogItem`.
    @objc(NewLog)
    static let newLog = "com.chartboost.CoreDemo.new_log"
}

extension NSNotification.Name {
    /// The associated `object` is a `LogItem`.
    static let newLog = NSNotification.Name(NSNotification.newLog)
}

@objc
@objcMembers
final class LogItem: NSObject {
    let text: String
    let secondaryText: String?

    init(text: String, secondaryText: String?) {
        self.text = text
        self.secondaryText = secondaryText
        super.init()
    }
}
