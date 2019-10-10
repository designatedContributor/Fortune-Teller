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
    private let keychainService: SecureKeyValueStorage

    init(networkService: Networking, userDefaultAnswer: UserDefault, keychainService: SecureKeyValueStorage) {
        self.networkService = networkService
        self.userDefaultAnswer = userDefaultAnswer
        self.keychainService = keychainService
    }

    func load(responseWith completion: @escaping (AnswersData) -> Void) {
        networkService.getAnswer(withCompletion: { [weak self] networkAnswer in
            guard let self = self else { return }

            if let networkAnswer = networkAnswer {
                let answer = AnswersData(withNetworkResponse: networkAnswer)
                self.keychainService.attemtCounter += 1
                self.keychainService.save()
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

    func saveAttemt() {
        keychainService.save()
    }

    func retrieveAttemts() -> Int {
        let attemts = keychainService.retrieve()
        return attemts
    }
}
