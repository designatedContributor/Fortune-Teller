//
//  ActivityModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

protocol ActivityModelProtocol {
    func setAnswer(withString string: String)
}

class ActivityModel {
    
    var networkService: NetwotkingServiceProtocol
    var delegate: ActivityModelProtocol!
    
    func giveAnswer() {
        networkService.getData() { networkAnswer in
            if let networkAnswer = networkAnswer {
                self.delegate.setAnswer(withString: networkAnswer.magic.answer)
            }
        }
    }
    
    init(networkService: NetwotkingService) {
        self.networkService = networkService
    }
}
