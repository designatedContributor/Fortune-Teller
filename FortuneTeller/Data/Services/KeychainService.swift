//
//  KeychainService.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/8/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class KeychainService: KeychainFunctional {

    func save(attemt: String) {
        KeychainWrapper.standard.set(attemt, forKey: "Attemts")
    }

    func retrieve() -> String {
        guard let value = KeychainWrapper.standard.string(forKey: "Attemts") else { return "0" }
        return value
    }
}
