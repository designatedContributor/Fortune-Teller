//
//  SecondViewController.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var answerInputTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    var activityModel: ActivityModel!
    
    let typeArray : [Type] = [.Affirmative, .Neutral, .Contrary]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.isHidden = true
        createPickerView()
        createToolBar()
    }
    
    func createPickerView() {
        let typePicker = UIPickerView()
        typePicker.dataSource = self
        typePicker.delegate = self
        typeTextField.text = typeArray[0].toString()
        typeTextField.inputView = typePicker
    }
    
    func createToolBar() {
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
        let toolBar = UIToolbar(frame: frame)
        let toolBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toolBarButtonTapped))
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexButton, toolBarButton], animated: true)
        typeTextField.inputAccessoryView = toolBar
    }
    
    @objc func toolBarButtonTapped() {
        typeTextField.resignFirstResponder()
    }
    
    @IBAction func saveAnswerTapped(_ sender: Any) {
        
        guard let text = answerInputTextField.text else { return }
        let isAnswerSaved = activityModel.currentAnswers.contains() { $0.answer == text }
        if isAnswerSaved {
            errorAlert()
        } else if text.count != 0 {
            if let type = Type(rawValue: typeTextField.text!) {
                activityModel.saveAnswer(answer: text, type: type)
                didSaveAlert()
                typeTextField.resignFirstResponder()
            }
        } else {
          warningLabel.isHidden = false
        }
    }
    
    func didSaveAlert() {
        let message = "Answer: \(answerInputTextField.text!), with type: \(typeTextField.text!)"
        let ac = UIAlertController(title: "You saved answer", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    func errorAlert() {
        let message = "The answer already exists"
        let ac = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(action)
        present(ac, animated: true)
    }
}


extension SettingsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == answerInputTextField {
            let currentText = textField.text ?? ""
            
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            if updatedText.count == 0 {
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

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = typeArray[row]
        return item.toString()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = typeArray[row]
        typeTextField.text = item.toString()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeArray.count
    }
}

