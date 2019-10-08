//
//  MainViewController.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    var mainViewModel: MainViewModel! //required to be implicit by contract

    var isFlipped = false

    private let containerView = UIView()
    private let questionView = UIView()
    private let answerView = UIView()
    private let questionLabel = UILabel()
    private let answerLabel = UILabel()
    private let closeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        button.setTitle(L10n.close, for: .normal)
        button.setTitleColor(UIColor(named: ColorName.neutralText), for: .normal)
        button.backgroundColor = .groupTableViewBackground
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.roundCorners(corners: [.bottomLeft, .bottomRight])
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.main
        setupSubviews()
        setupViews()
        setupLabels()
        setupConstraints()
    }

    // MARK: Shake gesture
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake && isFlipped == false {
            mainViewModel.shakeDetected()
        }
    }

    @objc private func closeButtonTapped(_ sender: Any) {
        flip()
    }

    private func setupConstraints() {
        let views = [containerView, answerView, questionView, answerLabel, questionLabel]
        views.forEach { $0.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        })
    }
        closeButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.top.equalTo(170)
        }
    }

    private func setupSubviews() {
        containerView.addSubview(answerView)
        containerView.addSubview(questionView)
        questionView.addSubview(questionLabel)
        answerView.addSubview(answerLabel)
        answerView.addSubview(closeButton)
        view.addSubview(containerView)
    }

    private func setupViews() {
        let items = [containerView, questionView, answerView]
        questionView.backgroundColor = .black
        items.forEach {
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupLabels() {
        let items = [answerLabel, questionLabel]
        questionLabel.text = L10n.shakeDeviceToGetTheAnswer
        questionLabel.textColor = .white
        items.forEach {
            $0.font = UIFont(font: FontFamily.DigitalStripBB.boldItalic, size: 20)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }
}

extension MainViewController: MainViewModelDelegate {
    func flip() {
        isFlipped = !isFlipped
        let fromView = isFlipped ? questionView : answerView
        let toView = isFlipped ? answerView : questionView
        let options: UIView.AnimationOptions = [.curveEaseOut, .transitionFlipFromLeft, .showHideTransitionViews]
        UIView.transition(from: fromView, to: toView, duration: 1, options: options)
    }

    func setAnswer(answer: String, type: AnswerType) {
        DispatchQueue.main.async {
            self.answerLabel.text = answer
            switch type {
            case .affirmative:
                self.answerView.backgroundColor = UIColor(named: ColorName.affirmative)
                self.answerLabel.textColor = UIColor(named: ColorName.affirmativeText)
            case .neutral:
                self.answerView.backgroundColor = UIColor(named: ColorName.neutral)
                self.answerLabel.textColor = UIColor(named: ColorName.neutralText)
            case .contrary:
                self.answerView.backgroundColor = UIColor(named: ColorName.contrary)
                self.answerLabel.textColor = UIColor.red
            }
        }
    }
}
