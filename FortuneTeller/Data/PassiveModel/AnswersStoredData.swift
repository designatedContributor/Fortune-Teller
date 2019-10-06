//
//  Data.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/2/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

struct AnswersStoredData: Codable, Equatable {

    var answer: String = ""
    var question: String = ""
    var type: String = ""

    init(answer: String, type: String) {
        self.answer = answer
        self.type = type
    }
}
