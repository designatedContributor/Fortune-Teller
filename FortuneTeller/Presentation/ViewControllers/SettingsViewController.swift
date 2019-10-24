//
//  SettingsViewController.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/11/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {

    private lazy var tableView = UITableView(frame: .zero, style: .grouped)

    private lazy var createAnswerButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createAnswerTapped))
        return button
    }()

    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: L10n.edit, style: .plain, target: self, action: #selector(editButtonTapped))
        return button
    }()

    var settingsViewModel: SettingsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Asset.background.color
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.register(SavedAnswerCell.self, forCellReuseIdentifier: SavedAnswerCell.cellID)
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.setRightBarButton(editButton, animated: true)
        navigationItem.setLeftBarButton(createAnswerButton, animated: true)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsViewModel.performFetch()
        tableView.reloadData()
    }

    @objc private func editButtonTapped() {
        if tableView.numberOfRows(inSection: 0) == 0 {
            showAlert()
        }
        tableView.setEditing(!tableView.isEditing, animated: true)
        changeTitle()
    }

    @objc private func createAnswerTapped() {
        let controller = SaveAnswerViewController()
        controller.settingsViewModel = self.settingsViewModel
        settingsViewModel.saveAnswerDelegate = controller
        navigationController?.pushViewController(controller, animated: true)
    }

//swiftlint:disable line_length
    private func showAlert() {
        let alert = UIAlertController(title: L10n.answerHistoryIsMissing, message: L10n.thereIsNothingToEdit, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }

    private func changeTitle() {
        if tableView.isEditing && tableView.numberOfRows(inSection: 0) != 0 {
            editButton.title = L10n.done
        } else {
            editButton.title = L10n.edit
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {

        }
    }
}

// MARK: TableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsViewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedAnswerCell.cellID, for: indexPath) as? SavedAnswerCell else { return UITableViewCell() }
        let item = settingsViewModel.objectAtIndex(at: indexPath)
        cell.item = item
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Saved answers"
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = settingsViewModel.objectAtIndex(at: indexPath)
            settingsViewModel.removeItem(item: item)
            settingsViewModel.performFetch()
        }
    }
}

extension SettingsViewController: SettingsViewModelDelegate {
    func deleteRow(atIndex indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            self?.tableView.endUpdates()
        }
    }
}
