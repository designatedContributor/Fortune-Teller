//
//  AnswerHistoryCell.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/13/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit
import SnapKit

class SavedAnswerCell: UITableViewCell {

    static let cellID = String(describing: SavedAnswerCell.self)

    let typeView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorName.black.color
        view.layer.cornerRadius = 8
        return view
    }()

    var item: PresentableResponse? {
        didSet {
            guard let item = item else { return }
            textLabel?.text = item.answer
            detailTextLabel?.text = item.date
            switch item.type {
            case .affirmative: typeView.backgroundColor = ColorName.affirmative.color
            case .neutral: typeView.backgroundColor = ColorName.neutral.color
            case .contrary: typeView.backgroundColor = ColorName.contrary.color
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        accessoryType = .none
        selectionStyle = .none
        backgroundColor = Asset.tabbar.color
        textLabel?.textColor = ColorName.white.color
        detailTextLabel?.textColor = UIColor.gray
        addSubview(typeView)
        typeView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailingMargin.equalTo(-20)
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
