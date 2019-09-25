//
//  TabBarRootViewController.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/21/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

class TabBarRootVC: UITabBarController {

    let networkService = NetwotkingService()
    let answerBank = AnswerBank()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
