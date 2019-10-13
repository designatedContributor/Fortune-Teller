//
//  SaveAnswerVC.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/11/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit
import SnapKit

class SaveAnswerViewController: UIViewController {

    lazy var tableView = UITableView(frame: .zero, style: .grouped)

    lazy var barButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        button.isEnabled = false
        return button
    }()

    var settingsViewModel: SettingsViewModel!

    private var typePickerIsVisible = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.frame
        tableView.register(AnswerInputCell.self, forCellReuseIdentifier: "CellWithTextField")
        tableView.register(TypeDisplayCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(TypePickerCell.self, forCellReuseIdentifier: "CellWithTypePicker")
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
        settingsViewModel.saveAnswer(input: AnswersData(answer: text, type: type, date: Date()))
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

extension SaveAnswerViewController: UITableViewDataSource, UITableViewDelegate {

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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithTextField", for: indexPath) as? AnswerInputCell else { return UITableViewCell() }
            cell.isThereAnyText = { value in
                self.isSaveButtonActive(value: value)
            }
            return cell
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithTypePicker", for: indexPath) as?  TypePickerCell else { return UITableViewCell() }

            cell.whatType = { sender in
                let index = IndexPath(row: 0, section: 1)
                guard let typeDisplayCell = tableView.cellForRow(at: index) as? TypeDisplayCell else { return }
                switch sender.tag {
                case 1000: typeDisplayCell.typeLabel.text = "Affirmative"
                case 1001: typeDisplayCell.typeLabel.text = "Neutral"
                case 1002: typeDisplayCell.typeLabel.text = "Contrary"
                default: break
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "Pick type"
            return cell
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 {
            return 100
        } else {
            return 50
        }
    }
}

extension SaveAnswerViewController: SettingsViewModelDelegate {

    func didSaveAlert() {
        guard let view = navigationController?.view else { return }
        let hudView = HudView.hud(inView: view, animated: true)
        hudView.text = "Saved"
        afterDelay(0.6) {
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
