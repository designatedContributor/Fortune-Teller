//
//  PresentableResponse.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/2/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

struct PresentableResponse {
    var answer: String
    var type: AnswerType

    init(answer: String, type: AnswerType) {
        self.answer = answer
        self.type = type
    }

    init?(data: AnswersData) {
        guard let type = AnswerType(rawValue: data.type) else { return nil }
        self.type = type
        self.answer = data.answer.uppercased()
    }
}

enum AnswerType: String, CaseIterable {
    case affirmative = "Affirmative"
    case neutral = "Neutral"
    case contrary = "Contrary"
}
