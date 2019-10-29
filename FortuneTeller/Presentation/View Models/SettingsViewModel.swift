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
    private let activityModel: AnswersModel

    lazy var formatted: [String] = {
        return toString()
    }()

    init(activityModel: AnswersModel) {
        self.activityModel = activityModel
        subsribe()
    }

    //TableView Methods
    func numberOfRows() -> Int {
        let numberOfRows = activityModel.numberOfRows()
        return numberOfRows
    }

    func objectAtIndex(at indexPath: IndexPath) -> PresentableResponse {
        let answer = activityModel.objectAtIndex(at: indexPath)
        let output = PresentableResponse(data: answer)
        return output
    }

    func performFetch() {
        activityModel.performFetch()
    }

    func saveAnswer(input: PresentableResponse) {
        let item = AnswersData(answer: input.answer, type: input.type.rawValue, date: Date())
        let isAnswerSaved = activityModel.isSaved(answer: item)
        if isAnswerSaved == false && !input.answer.isEmpty {
            activityModel.saveAnswer(answer: item)
            saveAnswerDelegate.didSaveAlert()
        } else {
            saveAnswerDelegate.errorAlert()
        }
    }

    func addItem(item: PresentableResponse) {
        let input = AnswersData(answer: item.answer, type: item.type.rawValue, date: Date())
        activityModel.saveAnswer(answer: input)
    }

    func removeItem(item: PresentableResponse) {
        activityModel.deleteItem(withID: item.identifier)
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

    private func subsribe() {
        activityModel.observerCallBack = { [weak self] index in
            guard let self = self else {
                assertionFailure("self is nil")
                return
            }
            self.settingsDelegate.deleteRow(atIndex: index)
        }
    }
}
