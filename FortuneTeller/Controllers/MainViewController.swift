//
//  MainViewController.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var activityModel: ActivityModel!
    
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var isFlipped = false
    var spectator = "" {
        didSet {
            flip()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityModel.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        configureViews()
    }
    
    @IBAction func getAnswerTapped(_ sender: Any) {
        activityModel.giveAnswer()
    }
    
    func flip() {
        isFlipped = !isFlipped
        let fromView = isFlipped ? questionView : answerView
        let toView = isFlipped ? answerView : questionView
        UIView.transition(from: fromView!, to: toView!, duration: 1, options: [.curveEaseOut, .transitionFlipFromLeft, .showHideTransitionViews])
    }
    
    func configureViews() {
        questionView.layer.cornerRadius = 20
        questionView.clipsToBounds = true
        answerView.layer.cornerRadius = 20
        answerView.clipsToBounds = true
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
    }
}



extension MainViewController: ActivityModelProtocol {
    
    func setAnswer(withAnswer answer: String, forType type: Type) {
        DispatchQueue.main.async {
            self.answerLabel.text = answer
            self.spectator = answer
            switch type {
            case .Affirmative: self.answerView.backgroundColor = UIColor.green
            case .Neutral: self.answerView.backgroundColor = UIColor.cyan
            case .Contrary: self.answerView.backgroundColor = UIColor.red
            }
        }
    }
}
