//
//  SavedAnswerService.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/13/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation
import CoreData

class StoredAnswerService: DBClient {

    var fetchResults = [Answer]()

    lazy var persistentContainer: NSPersistentContainer = {
        let containter = NSPersistentContainer(name: L10n.savedAnswerModel)
        containter.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Could load data store: \(error)")
            }
        })
        return containter
    }()

    lazy var backgroundMOC: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return context
    }()

    func save(answer: AnswersData) {
        backgroundMOC.performAndWait {
            let storedAnswer = Answer(context: backgroundMOC)
            storedAnswer.answer = answer.answer
            storedAnswer.type = answer.type
            storedAnswer.date = answer.date

            do {
                try backgroundMOC.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }

    func delete(atIndex index: Int) {
        let object = fetchResults[index]
        backgroundMOC.delete(object)
        do {
            try backgroundMOC.save()
        } catch {
            fatalError("Error: \(error)")
        }
    }

    func getRandomAnswer() -> AnswersData {
        let badResponse = AnswersData(answer: "", type: L10n.contrary, date: Date())
        guard let random = fetchResults.randomElement() else { return badResponse }
        let randomAnswer = AnswersData(answer: random.answer, type: random.type, date: random.date)
        return randomAnswer
    }

    func loadAnswers() {
        let fetchRequest = Answer.createFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: L10n.date, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            fetchResults = try backgroundMOC.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    func isAnswerSaved(answer: AnswersData) -> Bool {
        var result = false
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
