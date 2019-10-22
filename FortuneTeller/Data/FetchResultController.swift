// swiftlint:disable line_length
//
//  FetchResultController.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/20/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.

import Foundation
import CoreData

class FetchResultController: NSObject, NSFetchedResultsControllerDelegate {

    var observer: ((Observable, IndexPath) -> Void)?

    var frcInstance: NSFetchedResultsController<Answer>!
    private let storedAnswerService: DBClient

    enum Observable {
        case insert
        case delete
    }

    init(storedAnswerService: DBClient) {
        self.storedAnswerService = storedAnswerService
        super.init()
        initializeFetchResultsController()
    }

    func delete(atIndex indexPath: IndexPath) {
        observer?(Observable.delete, indexPath)
    }

    func insert(atIndex indexPath: IndexPath) {
        observer?(Observable.insert, indexPath)
    }

    private func initializeFetchResultsController() {
        let fetchRequest = Answer.createFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Answer.date), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        frcInstance = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: storedAnswerService.backgroundMOC, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try frcInstance.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        frcInstance.delegate = self
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        if type == .delete {
            delete(atIndex: indexPath)
        }
        if type == .insert {
            insert(atIndex: indexPath)
        }
    }
}
