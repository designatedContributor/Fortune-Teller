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
    
    let networkService: NetwotkingService?
    let userDefaultAnswer: UserDefaultAnswer?
    weak var delegate: ActivityModelProtocol?
    
    func giveAnswer() {
        networkService?.getDataFromServer { networkAnswer in
            if let networkAnswer = networkAnswer {
                self.delegate?.setAnswer(withAnswer: networkAnswer.singleResponse.answer, forType: networkAnswer.singleResponse.type)
            } else {
                guard let defaultAnswer = self.userDefaultAnswer?.getRandomAnswer() else { return }
                self.delegate?.setAnswer(withAnswer: defaultAnswer.answer, forType: defaultAnswer.type)
            }
        }
    }
    
    func saveAnswer(answer: String, type: AnswerType) {
        userDefaultAnswer?.saveUserAnswer(answer: answer, type: type)
    }
    
    func isSaved(answer: String) -> Bool? {
        let result = userDefaultAnswer?.isAnswerSaved(answer: answer)
        return result
    }
    
    init(networkService: NetwotkingService, userDefaultAnswer: UserDefaultAnswer) {
        self.networkService = networkService
        self.userDefaultAnswer = userDefaultAnswer
    }
}
