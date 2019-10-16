//
//  AnswerInputCell.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/12/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

class AnswerInputCell: UITableViewCell {

    static let cellID = String(describing: AnswerInputCell.self)
    var isThereAnyText: ((Bool) -> Void)?

    let answerTextField: UITextField = {
        let textfield = UITextField()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        textfield.attributedPlaceholder = NSAttributedString(string: L10n.enterYourAnswer, attributes: attributes)
        textfield.borderStyle = .roundedRect
        textfield.textColor = ColorName.white.color
        textfield.backgroundColor = Asset.background.color
        return textfield
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = Asset.tabbar.color
        answerTextField.delegate = self

        addSubview(answerTextField)
        answerTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.leadingMargin.equalTo(20)
            make.trailingMargin.equalTo(-20)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AnswerInputCell: UITextFieldDelegate {
    //swiftlint:disable line_length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let oldText = answerTextField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        isThereAnyText?(newText.isEmpty)
        return true
    }
}
