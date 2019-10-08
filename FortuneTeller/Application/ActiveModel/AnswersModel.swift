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
    private let keychainService: KeychainFunctional

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

    func saveAttemt(attemt: String) {
        keychainService.save(attemt: attemt)
    }

    func retrieveAttemts() -> String {
        let attemts = keychainService.retrieve()
        return attemts
    }

    init(_ networkService: Networking, _ userDefaultAnswer: UserDefault, _ keychainService: KeychainFunctional) {
        self.networkService = networkService
        self.userDefaultAnswer = userDefaultAnswer
        self.keychainService = keychainService
    }
}
