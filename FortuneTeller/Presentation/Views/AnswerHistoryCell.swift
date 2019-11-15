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

    var item: PresentableResponse? {
        didSet {
            guard let item = item else { return }
            answerLabel.text = item.answer
            dateLabel.text = item.date
            switch item.type {
            case .affirmative:
                answerLabel.backgroundColor = ColorName.affirmative.color
                answerLabel.textColor = ColorName.affirmativeText.color
            case .neutral:
                answerLabel.backgroundColor = ColorName.neutral.color
                answerLabel.textColor = ColorName.neutralText.color
            case .contrary:
                answerLabel.backgroundColor = ColorName.contrary.color
                answerLabel.textColor = ColorName.red.color
            }
        }
    }

    var isEditing: Bool? {
        didSet {
            guard let isEditing = isEditing else { return }
            dateLabel.isHidden = isEditing
            imageView.isHidden = !isEditing
        }
    }

    override var isSelected: Bool {
        didSet {
            guard let isEditing = isEditing else { return }
            if isEditing {
                imageView.image = UIImage(asset: isSelected ? Asset.checked : Asset.unchecked)
            }
        }
    }

    let answerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorName.black.color
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()

    let answerLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.shakeDeviceToGetTheAnswer
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = ColorName.white.color
        label.font = FontFamily.DigitalStripBB.boldItalic.font(size: 16)
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = ColorName.groupTableView.color
        label.textColor = ColorName.black.color
        label.textAlignment = .center
        label.font = FontFamily.DigitalStripBB.boldItalic.font(size: 12)
        return label
    }()

    let imageView: UIImageView = {
        let image = UIImage(asset: Asset.unchecked)
        let view = UIImageView(image: image)
        view.isHidden = true
        return view
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.isHidden = true
        dateLabel.isHidden = false
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Asset.background.color

        answerLabel.addSubview(dateLabel)
        answerLabel.addSubview(imageView)
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

        dateLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(30)
            make.bottom.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.width.equalTo(22)
            make.height.equalTo(22)
            make.topMargin.equalTo(8)
            make.leadingMargin.equalTo(8)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
