//
//  SecondViewController.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet private weak var answerInputTextField: UITextField!
    @IBOutlet private weak var typeTextField: UITextField!
    @IBOutlet private weak var saveAnswerButton: UIButton!
    @IBOutlet private weak var warningLabel: UILabel!

    var settingsViewModel: SettingsViewModel! //required to be implicit by contract

    // MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.isHidden = true
        saveAnswerButton.layer.cornerRadius = 15

        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(gesture)
        createPickerView()
        createToolBar()
    }

    // MARK: Helper functions for UI
    private func createPickerView() {
        let typePicker = UIPickerView()
        typePicker.dataSource = self
        typePicker.delegate = self
        typeTextField.text = settingsViewModel.formatted[0]
        typeTextField.inputView = typePicker
    }

    private func createToolBar() {
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
        let toolBar = UIToolbar(frame: frame)
        let toolBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideKeyBoard))
        let systemItem = UIBarButtonItem.SystemItem.flexibleSpace
        let flexButton = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)

        toolBar.setItems([flexButton, toolBarButton], animated: true)
        typeTextField.inputAccessoryView = toolBar
    }

    @objc func hideKeyBoard() {
        typeTextField.resignFirstResponder()
        view.endEditing(true)
    }

    private func updateTextFields() {
        answerInputTextField.text = ""
    }

    // MARK: ACTIONS
    @IBAction private func saveAnswerTapped(_ sender: Any) {
        answerInputTextField.resignFirstResponder()
        typeTextField.resignFirstResponder()

        guard let type = AnswerType(rawValue: typeTextField.text!) else { return }
        guard let text = answerInputTextField.text else { return }

        settingsViewModel.saveAnswer(answer: text, type: type)
    }
}

extension SettingsViewController: SettingsViewModelDelegate {
    func displayWarning() {
        warningLabel.isHidden = false
    }

    func didSaveAlert() {
        let message = "Answer: \(answerInputTextField.text!), with type: \(typeTextField.text!)"
        let alertController = UIAlertController(title: "You saved answer", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: updateTextFields)
    }

    func errorAlert() {
        let controller = UIAlertController(title: "Sorry", message: L10n.theAnswerAlreadyExists, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: updateTextFields)
    }
}

// MARK: UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == answerInputTextField {

            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            if updatedText.isEmpty {
                warningLabel.isHidden = false
            } else {
                warningLabel.isHidden = true
                }
            }
            return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == answerInputTextField {
            typeTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: UIPickerViewDelegate & DataSource
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = settingsViewModel.formatted[row]
        return item
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = settingsViewModel.formatted[row]
        typeTextField.text = item
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return settingsViewModel.formatted.count
    }
}
