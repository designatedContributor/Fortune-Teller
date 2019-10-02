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

    init(answer: String, type: String) {
        self.answer = answer
        self.type = type
    }

    init(withNetworkResponse response: ResponsePackage) {
        self.answer = response.singleResponse.answer
        self.type = response.singleResponse.type
    }

    init(withStoredAnswer answer: AnswersStoredData) {
        self.answer = answer.answer
        self.type = answer.type
    }
}
