//
//  Protocols.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/2/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

protocol MainViewModelDelegate: class {
    func setAnswer(answer: String, type: AnswerType)
    func flip()
}

protocol SaveAnswerViewModelDelegate: class {
    func didSaveAlert()
    func errorAlert()
}

protocol SettingsViewModelDelegate: class {
    func deleteRow(atIndex indexPath: IndexPath)
}

protocol NetworkingClient: class {
    func getAnswer(withCompletion completion: @escaping (ResponsePackage?) -> Void)
}

protocol SecureKeyValueStorage: class {
    var attemtCounter: Int { get set }
    func save()
    func retrieve() -> Int
}

protocol SavedAnswerClient: class {
    var observerCallBack: ((IndexPath) -> Void)? { get set }
    func save(answer: AnswersData)
    func delete(withID identifier: String)
    func isAnswerSaved(answer: AnswersData) -> Bool
    func getRandomAnswer() -> AnswersData
    func numberOfRows() -> Int
    func objectAtIndex(at indexPath: IndexPath) -> Answer
    func performFetch()
}

protocol UserDefaultsClient {
    func save(answer: AnswersData)
    func delete(atIndex indexPaths: [IndexPath])
    func numberOfRows() -> Int
    func objectAtIndex(at indexPath: IndexPath) -> UserDefaultsAnswer
    func loadAnswers()
}
