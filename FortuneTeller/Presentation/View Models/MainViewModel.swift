//
//  MainViewModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 9/29/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

class MainViewModel {

    private let activityModel: ActiveModel
    var isFlipped = false

    var response: ((String, AnswerType) -> Void)? {
        didSet {
            activityModel.response = self.response
            }
        }

init(activityModel: ActiveModel) {
    self.activityModel = activityModel
    }
}
