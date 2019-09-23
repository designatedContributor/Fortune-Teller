//
//  Response.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

struct Response: Codable {
    var answer: String = ""
    var question: String = ""
    var type: AnswerType = .Affirmative
    
    init(answer: String, type: AnswerType) {
        self.answer = answer
        self.type = type
    }
}

enum AnswerType: String, Codable {
    case Affirmative
    case Neutral
    case Contrary
    
    func toString() -> String {
        return self.rawValue
    }
}
