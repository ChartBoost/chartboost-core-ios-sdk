// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import ChartboostCoreSDK
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        ChartboostCore.initializeSDK(with: SDKConfiguration(chartboostAppID: ""), modules: []) { result in
            print("ChartboostCore.initializeSDK() completion")
        }
    }
}
