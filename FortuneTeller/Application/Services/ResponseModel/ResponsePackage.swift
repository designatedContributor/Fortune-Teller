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
