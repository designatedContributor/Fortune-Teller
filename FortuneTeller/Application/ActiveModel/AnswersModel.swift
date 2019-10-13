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
    private let savedAnswerService: DBClient
    private let keychainService: SecureKeyValueStorage

    init(networkService: Networking, savedAnswerService: DBClient, keychainService: SecureKeyValueStorage) {
        self.networkService = networkService
        self.savedAnswerService = savedAnswerService
        self.keychainService = keychainService
    }

    func load(responseWith completion: @escaping (AnswersData) -> Void) {
        networkService.getAnswer(withCompletion: { [weak self] networkAnswer in
            guard let self = self else { return }

            if let networkAnswer = networkAnswer {
                let answer = AnswersData(withNetworkResponse: networkAnswer, date: Date())
                self.keychainService.attemtCounter += 1
                self.keychainService.save()
                self.savedAnswerService.save(answer: answer)
                completion(answer)
            } else {
                let dbAnswer = self.savedAnswerService.getRandomAnswer()
                completion(dbAnswer)
            }
        })
    }

    func saveAnswer(answer: AnswersData) {
        savedAnswerService.save(answer: answer)
    }

    func isSaved(answer: AnswersData) -> Bool {
        let result = savedAnswerService.isAnswerSaved(answer: answer)
        print(result)
        return result
    }

    func loadSavedAnswers() {
        savedAnswerService.loadAnswers()
    }

    func saveAttemt() {
        keychainService.save()
    }

    func getSavedAnswers() -> [AnswersData] {
        let answers = savedAnswerService.fetchResults
        let result = answers.map {
            AnswersData(withStoredAnswer: $0)
        }
        return result
    }

    func retrieveAttemts() -> Int {
        let attemts = keychainService.retrieve()
        return attemts
    }
}
