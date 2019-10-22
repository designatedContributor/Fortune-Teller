//
//  SaveAnswerVC.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/11/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit
import SnapKit

struct MagicConstants {
    static let heightForCell: CGFloat = 100
    static let heightForRegularCell: CGFloat = 50
    static let delay: Double = 0.7
}

class SaveAnswerViewController: UIViewController {

    lazy var tableView = UITableView(frame: .zero, style: .grouped)
    lazy var barButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: L10n.saveAnswer, style: .plain, target: self, action: #selector(saveTapped))
        button.isEnabled = false
        return button
    }()

    var settingsViewModel: SettingsViewModel!
    private var typePickerIsVisible = false

    // MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.frame
        tableView.backgroundColor = Asset.background.color
        tableView.register(AnswerInputCell.self, forCellReuseIdentifier: AnswerInputCell.cellID)
        tableView.register(TypeDisplayCell.self, forCellReuseIdentifier: TypeDisplayCell.cellID)
        tableView.register(TypePickerCell.self, forCellReuseIdentifier: TypePickerCell.cellID)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.setRightBarButton(barButton, animated: true)
    }

    @objc func saveTapped() {
        let textFieldIndex = IndexPath(row: 0, section: 0)
        let typeDisplayIndex = IndexPath(row: 0, section: 1)
        guard let textFieldCell = tableView.cellForRow(at: textFieldIndex) as? AnswerInputCell else { return }
        guard let typeDisplayCell = tableView.cellForRow(at: typeDisplayIndex) as? TypeDisplayCell else { return }
        guard let text = textFieldCell.answerTextField.text else { return }
        guard let type = typeDisplayCell.typeLabel.text else { return }
        guard let answertype = AnswerType(rawValue: type) else { return }
        settingsViewModel.saveAnswer(input: PresentableResponse(answer: text, type: answertype, date: "", identifier: ""))
    }

    private func showTypePicker() {
        typePickerIsVisible = true
        let indexPathPicker = IndexPath(row: 1, section: 1)
        tableView.insertRows(at: [indexPathPicker], with: .fade)
    }

    private func hideTypePicker() {
        if typePickerIsVisible {
            typePickerIsVisible = false
            let indexPathPicker = IndexPath(row: 1, section: 1)
            tableView.deleteRows(at: [indexPathPicker], with: .fade)
        }
    }

    private func updateTextFields() {
        let index = IndexPath(row: 1, section: 1)
        guard let cell = tableView.cellForRow(at: index) as? AnswerInputCell else { return }
        cell.answerTextField.text = ""
    }

    private func isSaveButtonActive(value: Bool) {
        if value {
            barButton.isEnabled = false
        } else {
            barButton.isEnabled = true
        }
    }
}

// MARK: UITableViewDataSource
extension SaveAnswerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && typePickerIsVisible {
            return 2
        } else {
            return 1
        }
    }
//swiftlint:disable line_length
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerInputCell.cellID, for: indexPath) as? AnswerInputCell else { return UITableViewCell() }
            cell.isThereAnyText = { [weak self] value in
                self?.isSaveButtonActive(value: value)
            }
            return cell
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TypePickerCell.cellID, for: indexPath) as?  TypePickerCell else { return UITableViewCell() }

            cell.whatType = { buttonType in
                let index = IndexPath(row: 0, section: 1)
                guard let typeDisplayCell = tableView.cellForRow(at: index) as? TypeDisplayCell else { return }
                switch buttonType {
                case .affirmative: typeDisplayCell.typeLabel.text = L10n.affirmative
                case .neutral: typeDisplayCell.typeLabel.text = L10n.neutral
                case .contrary: typeDisplayCell.typeLabel.text = L10n.contrary
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TypeDisplayCell.cellID, for: indexPath)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension SaveAnswerViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 {
            return MagicConstants.heightForCell
        } else {
            return MagicConstants.heightForRegularCell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 0 {
            if !typePickerIsVisible {
                showTypePicker()
            } else {
                hideTypePicker()
            }
        }
    }
}

// MARK: SettingsViewModelDelegate
extension SaveAnswerViewController: SettingsViewModelDelegate {

    func didSaveAlert() {
        guard let view = navigationController?.view else { return }
        let hudView = HudView.hud(inView: view, animated: true)
        hudView.text = L10n.saved
        afterDelay(MagicConstants.delay) {
            hudView.hide()
            self.navigationController?.popViewController(animated: true)
        }
    }

    func errorAlert() {
        let message = L10n.theAnswerAlreadyExists
        let title = L10n.sorry
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: updateTextFields)
    }
}
