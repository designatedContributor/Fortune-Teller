//
//  MainViewModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 9/29/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

class MainViewModel {

    weak var delegate: MainViewModelDelegate!
    var response = PresentableResponse(answer: "", type: .affirmative, date: "", identifier: UUID().uuidString) {
        willSet {
            self.delegate.setAnswer(answer: newValue.answer, type: newValue.type)
            self.delegate.flip()
        }
    }

    private let activityModel: AnswersModel
    init(activityModel: AnswersModel) {
        self.activityModel = activityModel
    }

    func shakeDetected() {
        loadNewAnswer { [weak self] presentableResponse in
            guard let self = self else { return }
            self.response = presentableResponse
        }
    }

    private func loadNewAnswer(completion: @escaping (PresentableResponse) -> Void) {
        activityModel.load { response in
            let answer = PresentableResponse(data: response)
            completion(answer)
        }
    }
}
