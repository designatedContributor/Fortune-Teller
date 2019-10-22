//
//  SavedAnswerService.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/13/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//
// swiftlint:disable line_length
import Foundation
import CoreData

class StoredAnswerService: DBClient {

    lazy var persistentContainer: NSPersistentContainer = {
        let containter = NSPersistentContainer(name: L10n.savedAnswerModel)
        containter.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Could load data store: \(error)")
            }
        })
        return containter
    }()

    lazy var mainMOC: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        return context
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
            storedAnswer.identifier = UUID().uuidString
            do {
                try backgroundMOC.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }

    func delete(withID identifier: String) {
        let request = Answer.createFetchRequest()
        request.predicate = NSPredicate(format: "identifier = %@", identifier)
        do {
            let objects = try mainMOC.fetch(request)
            guard let objectToDelete = objects.first else { return }
            mainMOC.delete(objectToDelete)
            do {
                try mainMOC.save()
            }
        } catch {}
    }

    func getRandomAnswer() -> AnswersData {
        var array = [Answer]()
        let request = Answer.createFetchRequest()
        request.fetchBatchSize = 5
            do {
                array = try mainMOC.fetch(request)
            } catch {}
        if let answer = array.randomElement() {
            return AnswersData(withStoredAnswer: answer)
        } else {
            let badResponse = AnswersData(answer: "Seems like you offline – add custom answer", type: L10n.contrary, date: Date())
            return badResponse
        }
    }

    func isAnswerSaved(answer: AnswersData) -> Bool {
        var result = false
        let element = answer.answer
        let request = Answer.createFetchRequest()
        request.predicate = NSPredicate(format: "answer = %@", element)
        do {
            let objects = try mainMOC.fetch(request)
            if  objects.first != nil {
                result = true
            }
        } catch {
            print(error.localizedDescription)
        }
        return result
    }
}
