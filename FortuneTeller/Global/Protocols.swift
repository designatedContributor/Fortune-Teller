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

protocol SettingsViewModelDelegate: class {
    func didSaveAlert()
    func errorAlert()
}

protocol Networking: class {
    func getAnswer(withCompletion completion: @escaping (ResponsePackage?) -> Void)
}

protocol SecureKeyValueStorage: class {
    var attemtCounter: Int { get set }
    func save()
    func retrieve() -> Int
}

protocol DBClient: class {
    var fetchResults: [Answer] { get set }
    func save(answer: AnswersData)
    func delete(atIndex index: Int)
    func isAnswerSaved(answer: AnswersData) -> Bool
    func getRandomAnswer() -> AnswersData
    func loadAnswers()
}
