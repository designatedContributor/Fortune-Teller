//
//  ActivityModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

protocol ActivityModelProtocol {
    func setAnswer(withAnswer answer: String, forType type: Type)
}

class ActivityModel: AnswerBankProtocol {
    
    var currentAnswers: [ResponseBody]
    
    var networkService: NetwotkingServiceProtocol
    var answerBank: AnswerBank
    var delegate: ActivityModelProtocol!
    
    func giveAnswer() {
        networkService.getData() { networkAnswer in
            if let networkAnswer = networkAnswer {
                self.delegate.setAnswer(withAnswer: networkAnswer.magic.answer, forType: networkAnswer.magic.type)
            } else {
                let answerFromBank = self.answerBank.getRandomAnswer()
                self.delegate.setAnswer(withAnswer: answerFromBank.0, forType: answerFromBank.1)
            }
        }
    }
    
    func saveAnswer(answer: String, type: Type) {
        answerBank.saveUserAnswer(answer: answer, type: type)
    }
    
    init(networkService: NetwotkingService, answerBank: AnswerBank, currentAnswers: [ResponseBody]) {
        self.networkService = networkService
        self.answerBank = answerBank
        self.currentAnswers = currentAnswers
    }
}
