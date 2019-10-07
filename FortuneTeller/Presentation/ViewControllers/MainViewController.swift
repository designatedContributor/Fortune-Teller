//
//  MainViewController.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: Outlets
    private var questionView: UIView!
    private var answerView: UIView!
    private var answerLabel: UILabel!
    private var containerView: UIView!
    private var closeButton: UIButton!

    var mainViewModel: MainViewModel! //required to be implicit by contract
    var isFlipped = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main"
        containerView = UIView(frame: CGRect(x: view.center.x - 100, y: view.center.y - 100, width: 200, height: 200))
        questionView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        questionView.backgroundColor = .black

        answerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        answerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        answerLabel.font = UIFont(name: "DigitalStripBB-BoldItalic", size: 20)
        answerLabel.numberOfLines = 0
        answerLabel.textAlignment = .center
        
        closeButton = UIButton(frame: CGRect(x: 0, y: 200 - 30, width: 200, height: 30))
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for:.touchUpInside)
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.backgroundColor = .groupTableViewBackground
        view.addSubview(containerView)
        containerView.addSubview(answerView)
        containerView.addSubview(questionView)
        answerView.addSubview(answerLabel)
        answerView.addSubview(closeButton)
        configureViews()
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

    private func configureViews() {
        questionView.layer.cornerRadius = 20
        answerView.layer.cornerRadius = 20
        containerView.layer.cornerRadius = 20
        closeButton.roundCorners(corners: [.bottomLeft, .bottomRight])
        answerView.clipsToBounds = true
    }
}

extension MainViewController: MainViewModelDelegate {
    func flip() {
        isFlipped = !isFlipped
        let fromView = isFlipped ? questionView : answerView
        let toView = isFlipped ? answerView : questionView
        let options: UIView.AnimationOptions = [.curveEaseOut, .transitionFlipFromLeft, .showHideTransitionViews]
        UIView.transition(from: fromView!, to: toView!, duration: 1, options: options)
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
