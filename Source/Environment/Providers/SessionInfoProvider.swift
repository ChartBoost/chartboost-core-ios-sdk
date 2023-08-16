// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import WebKit

/// Provides information related to the session.
protocol SessionInfoProvider {

    /// The current session, or `nil` if a session has not started yet.
    var session: AppSession? { get }

    /// Creates a new session and uses it to replace the previous value of ``session``.
    func reset()
}

/// Core's concrete implementation of ``SessionInfoProvider``.
final class ChartboostCoreSessionInfoProvider: SessionInfoProvider {

    @Atomic private(set) var session: AppSession?

    func reset() {
        logger.debug("New session started")

        session = AppSession()
    }
}

