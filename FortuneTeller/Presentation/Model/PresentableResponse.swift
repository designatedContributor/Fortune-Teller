//
//  PresentableResponse.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/2/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation
import UIKit

struct PresentableResponse {
    var answer: String
    var type: AnswerType
    var date: Date

    init(answer: String, type: AnswerType, date: Date) {
        self.answer = answer
        self.type = type
        self.date = date
    }

    init(data: AnswersData) {
        let type = AnswerType(rawValue: data.type)
        self.type = type ?? AnswerType.affirmative
        self.answer = data.answer.uppercased()
        self.date = data.date
    }
}

enum AnswerType: String, CaseIterable {
    case affirmative = "Affirmative"
    case neutral = "Neutral"
    case contrary = "Contrary"

    func toColor() -> UIColor {
        switch self {
        case .affirmative: return ColorName.affirmative.color
        case .neutral: return ColorName.neutral.color
        case .contrary: return ColorName.contrary.color
        }
    }
}
