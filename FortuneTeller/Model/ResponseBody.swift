//
//  Response.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

struct ResponseBody: Codable {
    var answer: String
    var question: String
    var type: String
}
