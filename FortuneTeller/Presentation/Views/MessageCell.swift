//
//  MessageCell.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/26/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

class ConventionalCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {

    }
}

class MessageCell: ConventionalCell {

    static let identifier = "MessageCell"

    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = UIColor.black
        textView.text = "Hey how are you"
        textView.backgroundColor = UIColor.clear
        return textView
    }()

    let textBubleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()

    override func setupViews() {
        addSubview(textBubleView)
        addSubview(messageTextView)
    }
}
