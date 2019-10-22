//
//  TypeDisplayCell.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/12/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//
import UIKit

class TypeDisplayCell: UITableViewCell {

    static let cellID = String(describing: TypeDisplayCell.self)

    lazy var typeLabel: UILabel = {
        let  label = UILabel()
        label.text = L10n.affirmative
        label.textColor = Asset.buttonColor.color
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let selectionView = UIView()
        selectionView.backgroundColor = Asset.selected.color
        selectedBackgroundView = selectionView
        backgroundColor = Asset.tabbar.color
        accessoryType = .disclosureIndicator
        textLabel?.text = L10n.pickType
        textLabel?.textColor = Asset.buttonColor.color
        addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.trailingMargin.equalTo(-30)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
