//
//  KeychainService.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/8/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class KeychainService: SecureKeyValueStorage {

    var attemtCounter: Int

    init() {
        self.attemtCounter = KeychainWrapper.standard.integer(forKey: L10n.attemts) ?? 0
    }

    func save() {
        KeychainWrapper.standard.set(attemtCounter, forKey: L10n.attemts)
    }

    func retrieve() -> Int {
        guard let value = KeychainWrapper.standard.integer(forKey: L10n.attemts) else { return 0 }
        return value
    }
}
