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
    
    var activityModel: ActivityModel!
    
    private var isFlipped = false
    private var spectator = "" {
        didSet {
            flip()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: Shake gesture
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if isFlipped == false && motion == .motionShake {
            activityModel?.giveAnswer()
        }
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if isFlipped == false && motion == .motionShake {
            activityModel?.giveAnswer()
        }
    }
    
    @IBAction private func closeButtonTapped(_ sender: Any) {
        flip()
    }
    
    private func flip() {
        isFlipped = !isFlipped
        let fromView = isFlipped ? questionView : answerView
        let toView = isFlipped ? answerView : questionView
        UIView.transition(from: fromView!, to: toView!, duration: 1, options: [.curveEaseOut, .transitionFlipFromLeft, .showHideTransitionViews])
    }
    
    private func configureViews() {
        questionView.layer.cornerRadius = 20
        answerView.layer.cornerRadius = 20
        containerView.layer.cornerRadius = 20
        closeButton.roundCorners(corners: [.bottomLeft, .bottomRight])
        answerView.clipsToBounds = true
    }
}

// MARK: Implementing ActivityModelProtocol
extension MainViewController: ActivityModelProtocol {
    
    func setAnswer(withAnswer answer: String, forType type: AnswerType) {
        DispatchQueue.main.async {
            self.answerLabel.text = answer
            self.spectator = answer
            
            switch type {
            
            case .Affirmative:
                self.answerView.backgroundColor = UIColor(named: ColorName.affirmative)
                self.answerLabel.textColor = UIColor(named: ColorName.affirmativeText)
            case .Neutral:
                self.answerView.backgroundColor = UIColor(named: ColorName.neutral)
                self.answerLabel.textColor = UIColor(named: ColorName.neutralText)
            case .Contrary:
                self.answerView.backgroundColor = UIColor(named: ColorName.contrary)
                self.answerLabel.textColor = UIColor.red
            }
        }
    }
}
