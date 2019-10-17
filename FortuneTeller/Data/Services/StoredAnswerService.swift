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
            storedAnswer.identifier = answer.identifier
            do {
                try backgroundMOC.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }

    func delete(withID identifier: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Answer")
        request.predicate = NSPredicate(format: "identifier = %@", identifier)
        do {
            let object = try backgroundMOC.fetch(request)
            guard let objectToDelete =  object.first as? NSManagedObject else { return }
            backgroundMOC.delete(objectToDelete)
            do {
                try backgroundMOC.save()
            } catch {
                print(error)
            }

        } catch {
            print(error)
        }
    }

    func getRandomAnswer() -> AnswersData {
        if let random = fetchResults.randomElement() {
            let randomAnswer = AnswersData(answer: random.answer, type: random.type, date: random.date, identifier: random.identifier)
            return randomAnswer
        } else {
            let badResponse = AnswersData(answer: "", type: L10n.contrary, date: Date(), identifier: "")
            return badResponse
        }
    }

    func loadAnswers() {
        let fetchRequest = Answer.createFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Answer.date), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            fetchResults = try backgroundMOC.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    func isAnswerSaved(answer: AnswersData) -> Bool {
        var result = true
        let elementID = answer.identifier
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Answer")
        request.predicate = NSPredicate(format: "identifier = %@", elementID)
        do {
            let objects = try backgroundMOC.fetch(request)
            result = objects.isEmpty
        } catch {

        }
        return result
    }
}
