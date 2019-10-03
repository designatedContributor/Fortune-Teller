//
//  ActivityModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

class AnswersModel {

    private let networkService: Networking
    private let userDefaultAnswer: UserDefault

    func load(responseWith completion: @escaping (AnswersData) -> Void) {
        networkService.getAnswer(withCompletion: { networkAnswer in
            if let networkAnswer = networkAnswer {
                let answer = AnswersData(withNetworkResponse: networkAnswer)
                completion(answer)
            } else {
                let dbAnswer = self.userDefaultAnswer.getRandomAnswer()
                completion(dbAnswer)
            }
        })
    }

    func saveAnswer(answer: AnswersData) {
        userDefaultAnswer.save(answer: answer)
    }

    func isSaved(answer: AnswersData) -> Bool {
        let result = userDefaultAnswer.isAnswerSaved(answer: answer)
        return result
    }

    func loadSavedAnswers() {
        userDefaultAnswer.loadAnswers()
    }

    init(_ networkService: Networking, _ userDefaultAnswer: UserDefault) {
        self.networkService = networkService
        self.userDefaultAnswer = userDefaultAnswer
    }
}
