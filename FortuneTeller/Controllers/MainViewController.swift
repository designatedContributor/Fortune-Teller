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
    @IBOutlet weak var answerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityModel.delegate = self
    }
    
    @IBAction func getAnswerTapped(_ sender: Any) {
       activityModel.giveAnswer()
    }
}


extension MainViewController: ActivityModelProtocol {
    
    func setAnswer(withAnswer answer: String, forType type: Type) {
        DispatchQueue.main.async {
            self.answerLabel.text = answer
            switch type {
            case .Affirmative: self.answerLabel.backgroundColor = UIColor.green
            case .Neutral: self.answerLabel.backgroundColor = UIColor.cyan
            case .Contrary: self.answerLabel.backgroundColor = UIColor.red
            }
        }
    }
}
