//
//  AnswerInputCell.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/12/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

class AnswerInputCell: UITableViewCell {

    var isThereAnyText : ((Bool) -> Void)?

    let answerTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your answer"
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .white
        return textfield
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        answerTextField.delegate = self

        addSubview(answerTextField)
        answerTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leadingMargin.equalTo(10)
            make.trailingMargin.equalTo(10)
            make.height.equalTo(30)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AnswerInputCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let oldText = answerTextField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        isThereAnyText?(newText.isEmpty)
        return true
    }
}
