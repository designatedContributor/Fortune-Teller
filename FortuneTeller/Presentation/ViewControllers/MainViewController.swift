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
    @IBOutlet private weak var questionView: UIView!
    @IBOutlet private weak var answerView: UIView!
    @IBOutlet private weak var answerLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var closeButton: UIButton!

    var mainViewModel: MainViewModel! //required to be implicit by contract

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    // MARK: Shake gesture
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            mainViewModel?.response = { [weak self] (answer, type) in
                self?.setAnswer(answer: answer, type: type)
                self?.flip()
            }
        }
    }

    private func flip() {
        mainViewModel.isFlipped = !mainViewModel.isFlipped
        let fromView = mainViewModel.isFlipped ? questionView : answerView
        let toView = mainViewModel.isFlipped ? answerView : questionView
        UIView.transition(from: fromView!, to: toView!, duration: 1, options: [.curveEaseOut, .transitionFlipFromLeft, .showHideTransitionViews])
    }

    @IBAction private func closeButtonTapped(_ sender: Any) {
        flip()
    }

    private func setAnswer(answer: String, type: AnswerType) {
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

    private func configureViews() {
        questionView.layer.cornerRadius = 20
        answerView.layer.cornerRadius = 20
        containerView.layer.cornerRadius = 20
        closeButton.roundCorners(corners: [.bottomLeft, .bottomRight])
        answerView.clipsToBounds = true
    }
}
