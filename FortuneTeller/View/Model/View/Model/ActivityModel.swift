//
//  ActivityModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

protocol ActivityModelProtocol: class {
    func setAnswer(withAnswer answer: String, forType type: AnswerType)
}

class ActivityModel {
    
    weak var networkService: NetwotkingServiceProtocol?
    weak var answerBank: AnswerBank?
    weak var delegate: ActivityModelProtocol?
    
    func giveAnswer() {
        networkService?.getData() { networkAnswer in
            if let networkAnswer = networkAnswer {
                self.delegate?.setAnswer(withAnswer: networkAnswer.magic.answer, forType: networkAnswer.magic.type)
            } else {
                let answerFromBank = self.answerBank?.getRandomAnswer()
                self.delegate?.setAnswer(withAnswer: answerFromBank!.0, forType: answerFromBank!.1)
            }
        }
    }
    
    func saveAnswer(answer: String, type: AnswerType) {
        answerBank?.saveUserAnswer(answer: answer, type: type)
    }
    
    func isSaved(answer: String) -> Bool? {
        let result = answerBank?.isAnswerSaved(answer: answer)
        return result
    }
    
    init(networkService: NetwotkingService, answerBank: AnswerBank) {
        self.networkService = networkService
        self.answerBank = answerBank
    }
}
