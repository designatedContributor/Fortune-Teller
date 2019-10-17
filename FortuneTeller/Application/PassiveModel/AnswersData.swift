//
//  AnswersData.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/2/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

struct AnswersData {
    var answer: String
    var type: String
    var date: Date
    var identifier: String

    init(answer: String, type: String, date: Date, identifier: String) {
        self.answer = answer
        self.type = type
        self.date = date
        self.identifier = UUID().uuidString
    }

    init(withNetworkResponse response: ResponsePackage, date: Date, identifier: String) {
        self.answer = response.singleResponse.answer
        self.type = response.singleResponse.type
        self.date = date
        self.identifier = UUID().uuidString
    }

    init(withStoredAnswer answer: Answer) {
        self.answer = answer.answer
        self.type = answer.type
        self.date = answer.date
        self.identifier = answer.identifier
    }
}
