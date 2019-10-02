//
//  ActivityModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

class AnswersModel {

    let networkService: NetworkingServiceDelegate
    let userDefaultAnswer: UserDefaultAnswerDelegate

    func load(responseWith completion: @escaping (AnswersData) -> Void) {
        networkService.getAnswer(withCompletion: { networkAnswer in
            if let networkAnswer = networkAnswer {
                let answer = AnswersData(withNetworkResponse: networkAnswer)
                completion(answer)
            } else {
                let dbAnswer = self.userDefaultAnswer.getRandomAnswer()
                completion(AnswersData(withStoredAnswer: dbAnswer))
            }
        })
    }

    func saveAnswer(answer: String, type: String) {
        userDefaultAnswer.save(answer: answer, type: type)
    }

    func isSaved(answer: String) -> Bool {
        let result = userDefaultAnswer.isAnswerSaved(answer: answer)
        return result
    }

    init(_ networkService: NetworkingServiceDelegate, _ userDefaultAnswer: UserDefaultAnswerDelegate) {
        self.networkService = networkService
        self.userDefaultAnswer = userDefaultAnswer
    }
}
