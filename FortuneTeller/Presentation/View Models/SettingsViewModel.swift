//
//  SettingsViewModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 9/29/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

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
        } else {
            delegate.displayWarning()
        }
    }

    func getAttempts() {
        let number = activityModel.retrieveAttemts()
        let attemt = String(number)
        delegate.updateAttemts(attemts: attemt)
    }

    private func toString() -> [String] {
        let input = AnswerType.allCases
        let output = input.map { $0.rawValue }
        return output
    }
}
