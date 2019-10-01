//
//  ActivityModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

class ActiveModel {

    let networkService: NetwotkingService?
    let userDefaultAnswer: UserDefaultAnswer?

    var response: ((String, AnswerType) -> Void)? {
        didSet {
            networkService?.getAnswer(withCompletion: { answer in
                if let networkAnswer = answer {
                    self.response?(networkAnswer.singleResponse.answer, networkAnswer.singleResponse.type)
                } else {
                    guard let defaultAnswer = self.userDefaultAnswer?.getRandomAnswer() else { return }
                    self.response?(defaultAnswer.answer, defaultAnswer.type)
                }
            })
        }
    }

    func saveAnswer(answer: String, type: AnswerType) {
        userDefaultAnswer?.save(answer: answer, type: type)
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
