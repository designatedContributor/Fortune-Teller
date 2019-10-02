//
//  Data.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/2/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

struct AnswersStoredModel: Codable {

    var answer: String = ""
    var question: String = ""
    var type: String = ""

    init(answer: String, type: String) {
        self.answer = answer
        self.type = type
    }
}

extension AnswersStoredModel {
    func toResponse(_ response: AnswersStoredModel) -> ResponsePackage {
        let badResponse = ResponsePackage(singleResponse: Response(answer: "Failed", type: .affirmative))

        let toAnswerType = AnswerType(rawValue: response.type)
        guard let type = toAnswerType else { return badResponse }
        let result = ResponsePackage(singleResponse: Response(answer: response.answer, type: type))
        return result
    }
}
