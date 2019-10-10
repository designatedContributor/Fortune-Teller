//
//  Protocols.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/2/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

protocol MainViewModelDelegate: class {
    func setAnswer(answer: String, type: AnswerType)
    func flip()
}

protocol SettingsViewModelDelegate: class {
    func didSaveAlert()
    func errorAlert()
    func displayWarning()
    func updateAttemts(attemts: String)
}

protocol Networking: class {
    func getAnswer(withCompletion completion: @escaping (ResponsePackage?) -> Void)
}

protocol UserDefault: class {
    func isAnswerSaved(answer: AnswersData) -> Bool
    func save(answer: AnswersData)
    func loadAnswers()
    func getRandomAnswer() -> AnswersData
}

protocol SecureKeyValueStorage: class {
    var attemtCounter: Int { get set }
    func save()
    func retrieve() -> Int
}
