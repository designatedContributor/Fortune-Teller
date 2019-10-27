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

class StoredAnswerService: NSObject, DBClient {

    // MARK: CoreData stack
    lazy var persistentContainer: NSPersistentContainer = {
        let containter = NSPersistentContainer(name: L10n.savedAnswerModel)
        containter.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Could load data store: \(error)")
            }
        })
        return containter
    }()

    lazy var mainMOC = persistentContainer.viewContext
    lazy var backgroundMOC: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return context
    }()

    // MARK: FRC related stuff
    var observerCallBack: ((IndexPath) -> Void)?

    private lazy var frcController: NSFetchedResultsController<Answer> = {
        let frcInstance = initializeFetchResultsController()
        return frcInstance
    }()

    func numberOfRows() -> Int {
        guard let sectionInfo = frcController.sections?[0] else { return 0 }
        return sectionInfo.numberOfObjects
    }

    func objectAtIndex(at indexPath: IndexPath) -> Answer {
        let object = frcController.object(at: indexPath)
        return object
    }

    func performFetch() {
        do {
            try frcController.performFetch()
        } catch {}
    }

    private func didDeleteRow(atIndexPath indexPath: IndexPath) {
        observerCallBack?(indexPath)
    }

    // MARK: Answer related actions
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
            let badResponse = AnswersData(answer: L10n.seemsLikeYouOfflineAddCustomAnswer,
                                          type: L10n.contrary,
                                          date: Date())
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

    // MARK: Setting up FRC
    private func initializeFetchResultsController() -> NSFetchedResultsController<Answer> {
        let fetchRequest = Answer.createFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Answer.date), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainMOC, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try controller.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        controller.delegate = self
        return controller
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension StoredAnswerService: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        if type == .delete {
            didDeleteRow(atIndexPath: indexPath)
        }
    }
}
