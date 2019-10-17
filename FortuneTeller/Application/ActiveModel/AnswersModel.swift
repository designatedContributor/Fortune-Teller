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
    private let storedAnswerService: DBClient
    private let keychainService: SecureKeyValueStorage

    init(networkService: Networking, savedAnswerService: DBClient, keychainService: SecureKeyValueStorage) {
        self.networkService = networkService
        self.storedAnswerService = savedAnswerService
        self.keychainService = keychainService
    }

    func load(responseWith completion: @escaping (AnswersData) -> Void) {
        networkService.getAnswer(withCompletion: { [weak self] networkAnswer in
            guard let self = self else { return }

            if let networkAnswer = networkAnswer {
                let answer = AnswersData(withNetworkResponse: networkAnswer, date: Date(), identifier: UUID().uuidString)
                self.keychainService.attemtCounter += 1
                self.keychainService.save()
                self.storedAnswerService.save(answer: answer)
                completion(answer)
            } else {
                let dbAnswer = self.storedAnswerService.getRandomAnswer()
                completion(dbAnswer)
            }
        })
    }

    func saveAnswer(answer: AnswersData) {
        storedAnswerService.save(answer: answer)
    }

    func deleteItem(withID identifier: String) {
        storedAnswerService.delete(withID: identifier)
    }

    func isSaved(answer: AnswersData) -> Bool {
        let result = storedAnswerService.isAnswerSaved(answer: answer)
        return result
    }

    func loadSavedAnswers() {
        storedAnswerService.loadAnswers()
    }

    func getSavedAnswers() -> [AnswersData] {
        let answers = storedAnswerService.fetchResults
        let result = answers.map {
            AnswersData(withStoredAnswer: $0)
        }
        return result
    }

    func saveAttemt() {
        keychainService.save()
    }

    func retrieveAttemts() -> Int {
        let attemts = keychainService.retrieve()
        return attemts
    }
}
