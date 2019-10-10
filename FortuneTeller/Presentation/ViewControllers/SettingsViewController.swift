//
//  SecondViewController.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    private lazy var answerInputTextField = UITextField()
    private lazy var typeTextField = UITextField()
    private lazy var saveAnswerButton = UIButton()
    private lazy var warningLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
    private lazy var counterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
    private lazy var stackView = UIStackView()

    var settingsViewModel: SettingsViewModel! //required to be implicit by contract

    // MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.settings
        answerInputTextField.delegate = self
        setupStackView()
        setupLabels()
        additionalConfigure()
        setupConstraints()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(gesture)
        createPickerView()
        createToolBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsViewModel.getAttempts()
    }

    // MARK: Helper functions for UI
    private func additionalConfigure() {
        answerInputTextField.placeholder = L10n.enterYourAnswer
        answerInputTextField.backgroundColor = ColorName.white.color
        typeTextField.backgroundColor = ColorName.white.color
        answerInputTextField.tintColor = .clear
        typeTextField.tintColor = .clear
        answerInputTextField.borderStyle = .roundedRect
        typeTextField.borderStyle = .roundedRect
        saveAnswerButton.layer.cornerRadius = 7
        saveAnswerButton.backgroundColor = ColorName.neutralText.color
        saveAnswerButton.setTitle(L10n.saveAnswer, for: .normal)
        saveAnswerButton.setTitleColor(ColorName.white.color, for: .normal)
        saveAnswerButton.addTarget(self, action: #selector(saveAnswerTapped), for: .touchUpInside)
    }

    private func setupLabels() {
        warningLabel.isHidden = true
        warningLabel.text = L10n.emptyField
        warningLabel.textColor = ColorName.red.color
        counterLabel.text = L10n.lifetimeApplicationPredictions
        counterLabel.textColor = ColorName.cyan.color
        counterLabel.numberOfLines = 0
        counterLabel.textAlignment = .right
        counterLabel.font = UIFont(font: FontFamily.DigitalStripBB.boldItalic, size: 16)
        view.addSubview(warningLabel)
        view.addSubview(counterLabel)
    }
    private func setupStackView() {
        stackView.addArrangedSubview(answerInputTextField)
        stackView.addArrangedSubview(typeTextField)
        stackView.addArrangedSubview(saveAnswerButton)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 37
        view.addSubview(stackView)
    }

    private func setupConstraints() {
        let elements = [answerInputTextField, typeTextField, saveAnswerButton]
        elements.forEach {
            $0.snp.makeConstraints({ make in
                make.height.equalTo(35)
            })
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(120)
            make.centerX.equalToSuperview()
            make.leadingMargin.lessThanOrEqualTo(50)
            make.trailingMargin.lessThanOrEqualTo(50)
        }

        warningLabel.snp.makeConstraints { make in
            make.leadingMargin.equalTo(50)
            make.top.equalTo(115)
        }

        counterLabel.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.centerX.equalToSuperview()
        }
    }

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
    @objc private func saveAnswerTapped() {
        answerInputTextField.resignFirstResponder()
        typeTextField.resignFirstResponder()

        guard let type = typeTextField.text else { return }
        guard let text = answerInputTextField.text else { return }

        settingsViewModel.saveAnswer(input: AnswersData(answer: text, type: type))
    }
}

extension SettingsViewController: SettingsViewModelDelegate {
    func updateAttemts(attemts: String) {
        counterLabel.text = L10n.lifetimeApplicationPredictions + " " + attemts
    }

    func displayWarning() {
        warningLabel.isHidden = false
    }

    func didSaveAlert() {
        let message = "Answer: \(answerInputTextField.text!), with type: \(typeTextField.text!)"
        let alertController = UIAlertController(title: L10n.youSavedAnswer, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: L10n.dismiss, style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: updateTextFields)
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

// MARK: UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    // swiftlint:disable line_length
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
    //swiftlint:enable line_length
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
