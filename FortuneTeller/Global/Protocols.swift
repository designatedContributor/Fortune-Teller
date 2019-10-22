//
//  Protocols.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/2/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit
import CoreData

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
    func insertRow(atIndex indexPath: IndexPath)
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
    var backgroundMOC: NSManagedObjectContext { get set }
//    var anotherMOC: NSManagedObjectContext { get set }
    func save(answer: AnswersData)
    func delete(withID identifier: String)
    func isAnswerSaved(answer: AnswersData) -> Bool
    func getRandomAnswer() -> AnswersData
}
