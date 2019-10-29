//
//  MainViewModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 9/29/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation
import RxSwift

class MainViewModel {

    let triggerShakeEvent = PublishSubject<Void>()
    let showAnswer = PublishSubject<PresentableResponse>()
    private let disposeBag = DisposeBag()

    private let activityModel: AnswersModel

    init(activityModel: AnswersModel) {
        self.activityModel = activityModel
        setupBinding()
    }

    private func setupBinding() {
        triggerShakeEvent
            .bind(to: activityModel.performLoad)
            .disposed(by: disposeBag)

        activityModel.deliverAnswer.subscribe(onNext: { [weak self] response in
            let answer = PresentableResponse(data: response)
            self?.showAnswer.onNext(answer)
        }).disposed(by: disposeBag)
    }
}
