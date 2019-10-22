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

    private lazy var totalAttemtsLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.lifetimeApplicationPredictions
        label.textColor = ColorName.white.color
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var createAnswerButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        button.setTitle(L10n.createCustomAnswer, for: .normal)
        button.backgroundColor = Asset.buttonColor.color
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(createAnswerTapped), for: .touchUpInside)
        return button
    }()

    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: L10n.edit, style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.setRightBarButton(button, animated: true)
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

        view.addSubview(tableView)
        view.addSubview(createAnswerButton)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(260)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        setupStackView()

        self.settingsViewModel.output = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalAttemtsLabel.text = L10n.lifetimeApplicationPredictions + " " + String(settingsViewModel.getAttemts())
        settingsViewModel.load()
        tableView.reloadData()
    }

    @objc private func editButtonTapped() {
        if settingsViewModel.nodes.isEmpty {
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
        if tableView.isEditing && !settingsViewModel.nodes.isEmpty {
            editButton.title = L10n.done
        } else {
            editButton.title = L10n.edit
        }
    }

    private func setupStackView() {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.addArrangedSubview(totalAttemtsLabel)
        stackView.addArrangedSubview(createAnswerButton)
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.topMargin.equalTo(20)
            make.leadingMargin.equalTo(30)
            make.trailingMargin.equalTo(-30)
            make.height.equalTo(120)
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {

        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsViewModel.nodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedAnswerCell.cellID, for: indexPath) as? SavedAnswerCell else { return UITableViewCell() }
        let item = settingsViewModel.nodes[indexPath.row]
        cell.item = item
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Saved answers"
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DispatchQueue.main.async {
                let item = self.settingsViewModel.nodes[indexPath.row]
                self.settingsViewModel.removeItem(item: item)
            }
        }
    }
}

extension SettingsViewController: SettingsViewModelDelegate {
    func deleteRow(atIndex indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        }
    }

    func insertRow(atIndex indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
}
