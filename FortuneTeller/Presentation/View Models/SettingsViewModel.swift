//
//  SettingsViewModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 9/29/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

class SettingsViewModel {

    private let activityModel: AnswersModel
    weak var delegate: SettingsViewModelDelegate!
    lazy var formatted = toString()

    func saveAnswer(answer: String, type: AnswerType) {
        let isAnswerSaved = activityModel.isSaved(answer: answer)

        if isAnswerSaved {
            delegate.errorAlert()
        } else if !answer.isEmpty {
            activityModel.saveAnswer(answer: answer, type: type)
            delegate.didSaveAlert()
        } else {
            delegate.displayWarning()
        }
    }

    init(activityModel: AnswersModel) {
        self.activityModel = activityModel
    }

    private func toString() -> [String] {
        let input = AnswerType.allCases
        let output = input.map { $0.rawValue }
        return output
    }
}
