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
    var date: String
    var identifier: String

    init(answer: String, type: AnswerType, date: String, identifier: String) {
        self.answer = answer
        self.type = type
        self.date = date
        self.identifier = identifier
    }

    init(data: AnswersData) {
        let type = AnswerType(rawValue: data.type)
        self.type = type ?? AnswerType.affirmative
        self.answer = data.answer.uppercased()
        self.date = format(date: data.date)
        self.identifier = data.identifier
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

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

private func format(date: Date) -> String {
    return dateFormatter.string(from: date)
}
