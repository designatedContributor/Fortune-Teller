//
//  SettingsViewModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 9/29/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

protocol SettingsViewModelProtocol: class {
    func didSaveAlert()
    func errorAlert()
    func displayWarning()
}

class SettingsViewModel {

    private let activityModel: ActiveModel

    let types: [AnswerType] = [.affirmative, .neutral, .contrary]
    weak var delegate: SettingsViewModelProtocol!

    func saveAnswer(answer: String, type: AnswerType) {
        let isAnswerSaved = activityModel.isSaved(answer: answer)
        guard let isSaved = isAnswerSaved else { return }

        if isSaved {
            delegate.errorAlert()
        } else if !answer.isEmpty {
                activityModel.saveAnswer(answer: answer, type: type)
                delegate.didSaveAlert()
            } else {
            delegate.displayWarning()
        }
    }

    init(activityModel: ActiveModel) {
        self.activityModel = activityModel
    }
}
