//
//  SettingsViewController.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/11/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: L10n.edit, style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.setRightBarButton(button, animated: true)
        return button
    }()

    var settingsViewModel: SettingsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.frame
        tableView.backgroundColor = Asset.background.color
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.register(AnswerHistoryCell.self, forCellReuseIdentifier: AnswerHistoryCell.cellID)
        tableView.dataSource = settingsViewModel
        tableView.delegate = self
        navigationItem.setRightBarButton(editButton, animated: true)
        view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsViewModel.loadAnswers()
        tableView.reloadData()
    }

    @objc private func editButtonTapped() {
        if settingsViewModel.getAnswers().isEmpty {
            showAlert()
        }
        tableView.setEditing(!tableView.isEditing, animated: true)
        changeTitle()
    }
//swiftlint:disable line_length
    private func showAlert() {
        let alert = UIAlertController(title: L10n.answerHistoryIsMissing, message: L10n.thereIsNothingToEdit, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }

    private func changeTitle() {
        if tableView.isEditing {
            editButton.title = L10n.done
        } else {
            editButton.title = L10n.edit
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            let controller = SaveAnswerViewController()
            controller.settingsViewModel = self.settingsViewModel
            settingsViewModel.delegate = controller
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
