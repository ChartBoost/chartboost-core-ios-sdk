// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import WebKit

protocol SessionInfoProvider {
    var session: AppSession? { get }
    func reset()
}

final class ChartboostCoreSessionInfoProvider: SessionInfoProvider {

    private(set) var session: AppSession?

    func reset() {
        session = AppSession()
    }
}

