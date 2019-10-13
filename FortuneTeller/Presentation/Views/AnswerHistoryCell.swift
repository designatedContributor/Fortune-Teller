//
//  AnswerHistoryCell.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/13/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit
import SnapKit

class AnswerHistoryCell: UITableViewCell {

    let typeView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorName.black.color
        view.layer.cornerRadius = 8
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .none
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
