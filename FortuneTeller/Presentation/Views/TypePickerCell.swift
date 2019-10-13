//
//  TypePickerCell.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/12/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

class TypePickerCell: UITableViewCell {

    var whatType: ((UIButton) -> Void)?

    private let affirmativeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.backgroundColor = ColorName.affirmative.color
        button.layer.cornerRadius = button.bounds.width / 2
        button.tag = 1000
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        return button
    }()

    private let neutralButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorName.neutral.color
        button.tag = 1001
        return button
    }()

    private let contraryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorName.contrary.color
        button.tag = 1002
        return button
    }()

    private var isActive: UIButton? {
        willSet {
            newValue?.layer.borderWidth = 1
            newValue?.layer.borderColor = UIColor.black.cgColor
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
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
                sender.layer.borderColor = UIColor.black.cgColor
                sender.layer.borderWidth = 1
            } else {
                button.layer.borderWidth = 0
            }
        }
        whatType?(sender)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
