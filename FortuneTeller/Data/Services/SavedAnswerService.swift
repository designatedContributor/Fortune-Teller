//
//  SavedAnswerService.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/13/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation
import CoreData

class SavedAnswerService: DBClient {

    var fetchResults = [Answer]()

    lazy var persistentContainer: NSPersistentContainer = {
        let containter = NSPersistentContainer(name: "SavedAnswerModel")
        containter.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Could load data store: \(error)")
            }
        })
        return containter
    }()

    lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext

    func save(answer: AnswersData) {
        let storedAnswer = Answer(context: managedObjectContext)
        storedAnswer.answer = answer.answer
        storedAnswer.type = answer.type
        storedAnswer.date = answer.date
        do {
           try managedObjectContext.save()
        } catch {
            fatalError("Error: \(error)")
        }

    }

    func getRandomAnswer() -> AnswersData {
        guard let random = fetchResults.randomElement() else { return AnswersData(answer: "", type: "Contrary", date: Date())}
        let randomAnswer = AnswersData(answer: random.answer, type: random.type, date: random.date)
        return randomAnswer
    }

    func loadAnswers() {
        let fetchRequest = Answer.createFetchRequest()
        do {
            fetchResults = try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    func isAnswerSaved(answer: AnswersData) -> Bool {
        var result = true
        let element = answer.answer
        fetchResults.forEach {
           if $0.answer == element {
                result = true
            } else {
                result = false
            }
        }
        return result
    }
}
