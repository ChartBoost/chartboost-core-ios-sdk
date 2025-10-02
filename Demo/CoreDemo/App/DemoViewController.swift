// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import UIKit

/// The main view controller of this demo app.
/// Users can switch between Swift and Objective C calls sent to the `ChartboostCore` SDK.
final class DemoViewController: UIViewController {
    private enum Constant {
        static let cellReuseIdentifier = "cell"
        static let buttonContainerPadding = CGFloat(12)
    }

    private enum Language: Int {
        case swift
        case objectiveC
    }

    @IBOutlet private weak var languageSwitchContainer: UIView!
    @IBOutlet private weak var languageSwitch: UISegmentedControl!

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.cellReuseIdentifier)
        }
    }

    @IBOutlet private weak var buttonContainer: UIStackView!

    private lazy var clearButton = UIBarButtonItem(
        barButtonSystemItem: .trash,
        target: self,
        action: #selector(removeAllLogs)
    )

    private var logItems: [LogItem] = []

    private var currentLanguage: Language {
        Language(rawValue: languageSwitch.selectedSegmentIndex) ?? .swift
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let languageToggleContainerHeight = languageSwitchContainer.frame.height
        let buttonContainerVerticalSpace = buttonContainer.frame.height + 2 * Constant.buttonContainerPadding
        tableView.contentInset = .init(
            top: languageToggleContainerHeight,
            left: 0,
            bottom: buttonContainerVerticalSpace,
            right: 0
        )
        tableView.scrollIndicatorInsets = .init(
            top: languageToggleContainerHeight,
            left: 0,
            bottom: 0,
            right: 0
        )

        NotificationCenter.default.addObserver(
            forName: .newLog,
            object: nil,
            queue: OperationQueue.main
        ) { notification in
            guard let logItem = notification.object as? LogItem else {
                return
            }

            self.logItems.insert(logItem, at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self.navigationItem.rightBarButtonItem = self.clearButton
        }
    }

    @IBAction private func didHitUpdateConsentStatusButton(_ sender: Any) {
        enum Action: String, CaseIterable {
            case reset = "Reset"
            case deny = "Deny"
            case grant = "Grant"
        }

        let language = currentLanguage
        let alert = UIAlertController(title: "Update Consent Status", message: nil, preferredStyle: .actionSheet)
        Action.allCases.forEach { action in
            alert.addAction(.init(title: action.rawValue, style: .default) { _ in
                switch language {
                case .swift:
                    switch action {
                    case .reset:
                        ChartboostCoreAdapter_Swift.shared.resetConsent()
                    case .deny:
                        ChartboostCoreAdapter_Swift.shared.denyConsent()
                    case .grant:
                        ChartboostCoreAdapter_Swift.shared.grantConsent()
                    }

                case .objectiveC:
                    switch action {
                    case .reset:
                        ChartboostCoreAdapter_ObjC.sharedInstance().resetConsent()
                    case .deny:
                        ChartboostCoreAdapter_ObjC.sharedInstance().denyConsent()
                    case .grant:
                        ChartboostCoreAdapter_ObjC.sharedInstance().grantConsent()
                    }
                }
            })
        }
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    @IBAction private func didHitShowConsentDialogButton(_ sender: Any) {
        let handler: (ConsentDialogType) -> Void = { [weak self] consentDialogType in
            guard let self else { return }

            switch self.currentLanguage {
            case .swift:
                ChartboostCoreAdapter_Swift.shared.showConsentDialog(consentDialogType: consentDialogType, from: self)
            case .objectiveC:
                ChartboostCoreAdapter_ObjC.sharedInstance().show(consentDialogType, from: self)
            }
        }

        let alert = UIAlertController(title: "Show Consent Dialog", message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "Concise", style: .default) { _ in
            handler(.concise)
        })
        alert.addAction(.init(title: "Detailed", style: .default) { _ in
            handler(.detailed)
        })
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    @IBAction private func didHitInitSDKButton(_ sender: Any) {
        switch currentLanguage {
        case .objectiveC:
            ChartboostCoreAdapter_ObjC.sharedInstance().initializeSDK()
        case .swift:
            ChartboostCoreAdapter_Swift.shared.initializeSDK()
        }
    }

    @objc
    private func removeAllLogs() {
        logItems.removeAll()
        tableView.reloadData()
        navigationItem.rightBarButtonItem = nil
    }
}

extension DemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        logItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let logItem = logItems[indexPath.row]
        let indexedText = "\(logItems.count - indexPath.row)\t\(logItem.text)"
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellReuseIdentifier, for: indexPath)

        if #available(iOS 14, *) {
            var content = cell.defaultContentConfiguration()
            content.text = indexedText
            content.secondaryText = logItem.secondaryText
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = indexedText
            cell.detailTextLabel?.text = logItem.secondaryText
        }

        return cell
    }
}
