//
//  MainViewController.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    var activityModel: ActivityModel!
    
    var isFlipped = false
    var spectator = "" {
        didSet {
            flip()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    //MARK: - Shake gesture
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if isFlipped == false {
            activityModel?.giveAnswer()
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        flip()
    }
    
    func flip() {
        isFlipped = !isFlipped
        let fromView = isFlipped ? questionView : answerView
        let toView = isFlipped ? answerView : questionView
        UIView.transition(from: fromView!, to: toView!, duration: 1, options: [.curveEaseOut, .transitionFlipFromLeft, .showHideTransitionViews])
    }
    
    func configureViews() {
        questionView.layer.cornerRadius = 20
        answerView.layer.cornerRadius = 20
        containerView.layer.cornerRadius = 20
        closeButton.roundCorners(corners: [.bottomLeft, .bottomRight])
        answerView.clipsToBounds = true
    }
}


//MARK: - Implementing ActivityModelProtocol
extension MainViewController: ActivityModelProtocol {
    
    func setAnswer(withAnswer answer: String, forType type: AnswerType) {
        DispatchQueue.main.async {
            self.answerLabel.text = answer
            self.spectator = answer
            
            switch type {
            
            case .Affirmative:
                self.answerView.backgroundColor = UIColor.MyColorTheme.Affirmative;
                self.answerLabel.textColor = UIColor.MyColorTheme.AffirmativeText
            case .Neutral:
                self.answerView.backgroundColor = UIColor.MyColorTheme.Neutral;
                self.answerLabel.textColor = UIColor.MyColorTheme.NeutralText
            case .Contrary:
                self.answerView.backgroundColor = UIColor.MyColorTheme.Contrary;
                self.answerLabel.textColor = UIColor.red
            }
        }
    }
}
