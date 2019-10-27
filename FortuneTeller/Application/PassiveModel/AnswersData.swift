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
    var identifier = ""

    init(answer: String, type: String, date: Date) {
        self.answer = answer
        self.type = type
        self.date = date
    }

    init(withNetworkResponse response: ResponsePackage, date: Date) {
        self.answer = response.singleResponse.answer
        self.type = response.singleResponse.type
        self.date = date
    }

    init(withStoredAnswer answer: Answer) {
        self.answer = answer.answer
        self.type = answer.type
        self.date = answer.date
        self.identifier = answer.identifier
    }

    init(withUserDefaults answer: UserDefaultsAnswer) {
        self.answer = answer.answer
        self.type = answer.type
        self.date = answer.date
    }
}
