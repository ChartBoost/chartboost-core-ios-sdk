// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A wrapper that holds a weak reference to an object.
struct WeakWrapper<Object: AnyObject> {

    /// The wrapped object.
    weak var value: Object?

    /// Instantiates the wrapper with the passed object.
    init(_ value: Object) {
        self.value = value
    }
}
