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
}

protocol NetworkingServiceDelegate: class {
    func getAnswer(withCompletion completion: @escaping (ResponsePackage?) -> Void)
}

protocol UserDefaultAnswerDelegate: class {
    func isAnswerSaved(answer: String) -> Bool
    func save(answer: String, type: String)
    func loadAnswers()
    func getRandomAnswer() -> AnswersStoredData
}
