//
//  ActivityModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation
import RxSwift

class AnswersModel {

    private let networkService: NetworkingClient
    private let storedAnswerService: SavedAnswerClient
    private let userDefaultsService: UserDefaultsClient
    private let keychainService: SecureKeyValueStorage

    var observerCallBack: ((IndexPath) -> Void)?

    let deliverAnswer = PublishSubject<AnswersData>()
    let disposableBag = DisposeBag()

    init(networkService: NetworkingClient,
         savedAnswerService: SavedAnswerClient,
         keychainService: SecureKeyValueStorage,
         userDefaultsService: UserDefaultsClient) {
        self.networkService = networkService
        self.storedAnswerService = savedAnswerService
        self.keychainService = keychainService
        self.userDefaultsService = userDefaultsService
        storedServiceBinding()
    }

    func load() {
        networkService.getAnswer(withCompletion: { [weak self] networkAnswer in
            guard let self = self else { return }
            if let networkAnswer = networkAnswer {
                let answer = AnswersData(withNetworkResponse: networkAnswer, date: Date())
                self.keychainService.attemtCounter += 1
                self.keychainService.save()
                self.storedAnswerService.save(answer: answer)
                self.userDefaultsService.save(answer: answer)
                self.deliverAnswer.onNext(answer)
            } else {
                let dbAnswer = self.storedAnswerService.getRandomAnswer()
                self.userDefaultsService.save(answer: dbAnswer)
                self.deliverAnswer.onNext(dbAnswer)
            }
        })
    }

    // MARK: Settings methods

    func saveAnswer(answer: AnswersData) {
        storedAnswerService.save(answer: answer)
    }

    func deleteItem(withID identifier: String) {
        storedAnswerService.delete(withID: identifier)
    }

    func numberOfRows() -> Int {
        let numberOfRows = storedAnswerService.numberOfRows()
        return numberOfRows
    }

    func objectAtIndex(at indexPath: IndexPath) -> AnswersData {
        let answer = storedAnswerService.objectAtIndex(at: indexPath)
        let output = AnswersData(withStoredAnswer: answer)
        return output
    }

    func performFetch() {
        storedAnswerService.performFetch()
    }

    func isSaved(answer: AnswersData) -> Bool {
        let result = storedAnswerService.isAnswerSaved(answer: answer)
        return result
    }

    // MARK: Keychain Methods

    func saveAttemt() {
        keychainService.save()
    }

    func retrieveAttemts() -> Int {
        let attemts = keychainService.retrieve()
        return attemts
    }

    // MARK: Recent Answers Methods

    func recentAnswerAtIndex(indexPath: IndexPath) -> AnswersData {
        let answer = userDefaultsService.objectAtIndex(at: indexPath)
        let output = AnswersData(withUserDefaults: answer)
        return output
    }

    func numberOfRowsForRecentAnswers() -> Int {
        let quantity = userDefaultsService.numberOfRows()
        return quantity
    }

    func deleteRecentAnswers(atIndexPath: [IndexPath]) {
        userDefaultsService.delete(atIndex: atIndexPath)
    }

    // MARK: Bindings

    private func storedServiceBinding() {
        storedAnswerService.observerCallBack = { [weak self] index in
            self?.observerCallBack?(index)
        }
    }

}
