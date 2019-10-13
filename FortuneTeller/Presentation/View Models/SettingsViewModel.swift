//
//  SettingsViewModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 9/29/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

class SettingsViewModel {

    weak var delegate: SettingsViewModelDelegate!
    lazy var formatted: [String] = {
        return toString()
    }()

    private let activityModel: AnswersModel

    init(activityModel: AnswersModel) {
        self.activityModel = activityModel
    }

    func saveAnswer(input: AnswersData) {
        let isAnswerSaved = activityModel.isSaved(answer: input)
        if isAnswerSaved {
            delegate.errorAlert()
        } else if !input.answer.isEmpty {
            activityModel.saveAnswer(answer: input)
            delegate.didSaveAlert()
        }
    }

    func getAnswers() -> [PresentableResponse] {
        let answers = activityModel.getSavedAnswers()
        let result = answers.map {
            PresentableResponse(data: $0)
        }
        return result
    }

    func loadAnswers() {
        activityModel.loadSavedAnswers()
    }

    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    func getAttemts() -> String {
        let result = String(activityModel.retrieveAttemts())
        return result
    }
    private func toString() -> [String] {
        let input = AnswerType.allCases
        let output = input.map { $0.rawValue }
        return output
    }
}
