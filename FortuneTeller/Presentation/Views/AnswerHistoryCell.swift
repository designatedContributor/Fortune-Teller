//
//  AnswerHistoryCell.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/19/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit
import SnapKit
class AnswerHistoryCell: UICollectionViewCell {

    static let cellID = String(describing: AnswerHistoryCell.self)

    let answerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorName.black.color
        view.layer.cornerRadius = 15
        return view
    }()

    let answerLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.shakeDeviceToGetTheAnswer
        label.textColor = ColorName.white.color
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = ColorName.white.color

        answerView.addSubview(answerLabel)
        contentView.addSubview(answerView)

        answerView.snp.makeConstraints { make in
            make.topMargin.equalTo(10)
            make.leadingMargin.equalTo(10)
            make.trailingMargin.equalTo(-10)
            make.bottomMargin.equalTo(-10)
        }

        answerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
