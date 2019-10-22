//
//  SettingsViewModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 9/29/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewModel {

    weak var saveAnswerDelegate: SaveAnswerViewModelDelegate!
    weak var settingsDelegate: SettingsViewModelDelegate!

    let fetchResultController: FetchResultController

    var output: (() -> Void)?

    var nodes: [PresentableResponse] = [] {
        willSet {
            output?()
        }
    }

    lazy var formatted: [String] = {
        return toString()
    }()

    private let activityModel: AnswersModel

    init(activityModel: AnswersModel, fetchResultController: FetchResultController) {
        self.activityModel = activityModel
        self.fetchResultController = fetchResultController
        nodes = createNodes()
        subsribe()
    }

    func saveAnswer(input: PresentableResponse) {
        let item = AnswersData(answer: input.answer, type: input.type.rawValue, date: Date())
        let isAnswerSaved = activityModel.isSaved(answer: item)
        if isAnswerSaved == false && !input.answer.isEmpty {
            activityModel.saveAnswer(answer: item)
            nodes = createNodes()
            saveAnswerDelegate.didSaveAlert()
        } else {
            saveAnswerDelegate.errorAlert()
        }
    }

    func load() {
        self.nodes = createNodes()
    }

    func getAttemts() -> Int {
        let result = activityModel.retrieveAttemts()
        return result
    }

    private func toString() -> [String] {
        let input = AnswerType.allCases
        let output = input.map { $0.rawValue }
        return output
    }

    private func deleteItem(atIndexPath: IndexPath) {
        self.nodes.remove(at: atIndexPath.row)
    }

    private func subsribe() {
        fetchResultController.observer = { [weak self] observable, index in
            guard let self = self else {
                assertionFailure("self is nil")
                return
            }
            switch observable {
            case .delete:
                self.settingsDelegate.deleteRow(atIndex: index)
                self.deleteItem(atIndexPath: index)
            case .insert:
                self.settingsDelegate.insertRow(atIndex: index)
            }
        }
    }

    func addItem(item: PresentableResponse) {
        let input = AnswersData(answer: item.answer, type: item.type.rawValue, date: Date())
        activityModel.saveAnswer(answer: input)
    }

    func removeItem(item: PresentableResponse) {
        activityModel.deleteItem(withID: item.identifier)
    }

    func createNodes() -> [PresentableResponse] {
        guard let objects = fetchResultController.frcInstance.fetchedObjects else { return [PresentableResponse]() }
        let result = objects.map {
            PresentableResponse(storedAnswer: $0)
        }
        return result
    }
}
