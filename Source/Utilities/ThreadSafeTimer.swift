// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A wrapper over `Timer` that makes dealing with timers a bit easier, abstracting away some
/// of the thread-related particularities of `Timer`.
final class ThreadSafeTimer {
    private var systemTimer: Timer?

    private init() {}

    // Creates the operation retry and schedules with the specified delay.
    static func scheduledTimer(
        withTimeInterval timeInterval: TimeInterval,
        completion: @escaping (ThreadSafeTimer) -> Void
    ) -> ThreadSafeTimer {
        let timer = ThreadSafeTimer()
        // Runloop scheduling must be performed on the main thread
        DispatchQueue.main.async {
            let systemTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak timer] _ in
                guard let timer else { return }
                // Execute completion
                completion(timer)
                // Clean up the timer
                // Note calls to invalidate() must be made from the same thread the timer was created.
                timer.systemTimer?.invalidate()
                timer.systemTimer = nil
            }
            timer.systemTimer = systemTimer
        }
        return timer
    }

    /// Cancels the timer so it never gets fired.
    func cancel() {
        // Calls to invalidate() must be made from the same thread the timer was created.
        DispatchQueue.main.async {
            self.systemTimer?.invalidate()
            self.systemTimer = nil
        }
    }
}
