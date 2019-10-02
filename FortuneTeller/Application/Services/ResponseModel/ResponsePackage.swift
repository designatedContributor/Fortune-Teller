//
//  ResponseHeader.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

struct ResponsePackage: Codable {
    var singleResponse: Response

    enum CodingKeys: String, CodingKey {
        case singleResponse = "magic"
    }
}

extension ResponsePackage {
    func toAnswersData(response: ResponsePackage) -> AnswersData {
        let result = AnswersData(answer: response.singleResponse.answer, type: response.singleResponse.type)
        return result
    }
}
