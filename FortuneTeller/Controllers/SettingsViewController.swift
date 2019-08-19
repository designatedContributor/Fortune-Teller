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
    
    var activityModel: ActivityModel!
    
    let typeArray : [Type] = [.Affirmative, .Neutral, .Contrary]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
    }
    
    func createPickerView() {
        let typePicker = UIPickerView()
        typePicker.dataSource = self
        typePicker.delegate = self
        typePicker.selectRow(0, inComponent: 0, animated: true)
        typePicker.reloadComponent(0)
        
        typeTextField.inputView = typePicker
    }
    
    @IBAction func saveAnswerTapped(_ sender: Any) {
        
        guard let text = answerInputTextField.text else { return }
        if text.count != 0 {
            if let type = Type(rawValue: typeTextField.text!) {
                activityModel.saveAnswer(answer: text, type: type)
                typeTextField.resignFirstResponder()
            }
        }
    }
}


extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == answerInputTextField {
            typeTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let item = typeArray[row]
        return item.toString()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let item = typeArray[row]
        typeTextField.text = item.toString()
    }
}

extension SettingsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeArray.count
    }
}


