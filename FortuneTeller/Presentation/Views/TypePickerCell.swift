//
//  TypePickerCell.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/12/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

enum ButtonType: Int, CaseIterable {
    case affirmative = 1000
    case contrary = 1001
    case neutral = 1002
}

private func createButton(withType type: ButtonType) -> UIButton {
    let button = UIButton()
    switch type {
    case .affirmative:
        button.backgroundColor = ColorName.affirmative.color
        button.tag = 1000
    case .contrary:
        button.backgroundColor = ColorName.neutral.color
        button.tag = 1001
    case .neutral:
        button.backgroundColor = ColorName.contrary.color
        button.tag = 1002
    }
    return button
}

class TypePickerCell: UITableViewCell {

    static let cellID = String(describing: TypePickerCell.self)
    var whatType: ((ButtonType) -> Void)?

    private var isActive: UIButton? {
        willSet {
            newValue?.layer.borderWidth = 2
            newValue?.layer.borderColor = UIColor.gray.cgColor
        }
    }

    let affirmativeButton = createButton(withType: .affirmative)
    let neutralButton = createButton(withType: .neutral)
    let contraryButton = createButton(withType: .contrary)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = Asset.tabbar.color
        let stackView = UIStackView(arrangedSubviews: [affirmativeButton, neutralButton, contraryButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing

        let elements = [affirmativeButton, neutralButton, contraryButton]

        elements.forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(50)
                make.height.equalTo(50)
            }
        }

        elements.forEach {
            $0.layer.cornerRadius = 25
            $0.layer.masksToBounds = true
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leadingMargin.equalTo(40)
            make.trailingMargin.equalTo(-40)
            make.centerY.equalToSuperview()
        }
    }

    @objc private func buttonTapped(sender: UIButton) {
        let buttons = [affirmativeButton, neutralButton, contraryButton]
        for button in buttons {
            if button.tag == sender.tag {
                sender.layer.borderColor = ColorName.white.color.cgColor
                sender.layer.borderWidth = 3
            } else {
                button.layer.borderWidth = 0
            }
        }

        let types = ButtonType.allCases
        types.forEach {
            if $0.rawValue == sender.tag {
                whatType?($0)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
