//
//  Data.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/2/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

struct UserDefaultsResponse: Codable {

    var answer: String = ""
    var question: String = ""
    var type: AnswerType = .affirmative

    init(answer: String, type: AnswerType) {
        self.answer = answer
        self.type = type
    }
}

extension UserDefaultsResponse {
    func toResponse(_ response: UserDefaultsResponse) -> ResponsePackage {
        let result = ResponsePackage(singleResponse: Response(answer: response.answer, type: response.type))
        return result
    }
}
