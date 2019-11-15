//
//  Data.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/2/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

struct UserDefaultsAnswer: Codable {

    let answer: String
    let type: String
    let date: Date
    let identifier: String

    init(answer: String, type: String, date: Date, identifier: String) {
        self.answer = answer
        self.type = type
        self.date = date
        self.identifier = identifier
    }
}
