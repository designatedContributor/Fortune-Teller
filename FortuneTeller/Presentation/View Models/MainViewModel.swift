//
//  MainViewModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 9/29/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

class MainViewModel {

    private let activityModel: AnswersModel
    weak var delegate: MainViewModelDelegate!

    var response = PresentableResponse(answer: "", type: .affirmative) {
        willSet {
            self.delegate.setAnswer(answer: newValue.answer, type: newValue.type)
            self.delegate.flip()
        }
    }

    func shakeDetected() {
        loadNewAnswer { presentableResponse in
            self.response = presentableResponse
        }
    }

    private func loadNewAnswer(completion: @escaping (PresentableResponse) -> Void) {
        activityModel.load { response in
            guard let answer = PresentableResponse(data: response) else { return }
            completion(answer)
        }
    }

    init(activityModel: AnswersModel) {
        self.activityModel = activityModel
    }
}
