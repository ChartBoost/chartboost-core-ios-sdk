// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

extension URL {
    /// An init for obtaining a nonnull `URL` assuming the given string represents a valid URL.
    /// - Parameter safeString: A string that representing a valid URL.
    init(safeString: String) {
        if #available(iOS 17.0, *) {
            // On iOS 17+, `URL(string:)` assumes `encodingInvalidCharacters` being `true`, which is
            // inconsistent with older iOS versions and makes bad URL less obvious.
            guard let url = URL(string: safeString, encodingInvalidCharacters: false) else {
                fatalError("Failed to obtain a valid `URL` from \"\(safeString)\"")
            }
            self = url
        } else {
            guard let url = URL(string: safeString) else {
                fatalError("Failed to obtain a valid `URL` from \"\(safeString)\"")
            }
            self = url
        }
    }
}
