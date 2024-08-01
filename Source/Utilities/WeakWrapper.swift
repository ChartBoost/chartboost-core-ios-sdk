// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A wrapper that holds a weak reference to an object.
/// Note that the `Object` type cannot be a Swift protocol, and the workaround is declaring it as a Objective-C protocol with `@objc`.
/// This workaround does not work if a var or func in the protocol reference to a Swift exclusive type such as struct.
/// See this discussion for alternatives:
///   https://stackoverflow.com/questions/51486965/type-a-requires-that-type-b-be-a-class-type-swift-4
struct WeakWrapper<Object: AnyObject> {
    /// The wrapped object.
    weak var value: Object?

    /// Instantiates the wrapper with the passed object.
    init(_ value: Object) {
        self.value = value
    }
}
