//
//  TabBarRootViewController.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/21/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let activityModel = ActivityModel(networkService: NetwotkingService(), userDefaultAnswer: UserDefaultAnswer())
        activityModel.userDefaultAnswer?.loadAnswers()

        let mainViewController = self.viewControllers?[0] as? MainViewController
        mainViewController?.activityModel = activityModel
        mainViewController?.tabBarItem.image = UIImage(asset: Asset._8BallInsideACircle2)
        activityModel.delegate = mainViewController

        let settingsViewController = self.viewControllers?[1] as? SettingsViewController
        settingsViewController?.activityModel = activityModel
        settingsViewController?.tabBarItem.image = UIImage(asset: Asset.gear)
    }
}
