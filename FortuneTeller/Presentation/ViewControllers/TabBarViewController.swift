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

        let activityModel = ActiveModel(networkService: NetwotkingService(), userDefaultAnswer: UserDefaultAnswer())
        activityModel.userDefaultAnswer?.loadAnswers()

        let mainViewModel = MainViewModel(activityModel: activityModel)
        let settingsViewModel = SettingsViewModel(activityModel: activityModel)

        let mainViewController = self.viewControllers?[0] as? MainViewController
        mainViewController?.mainViewModel = mainViewModel
        mainViewController?.tabBarItem.image = UIImage(asset: Asset._8BallInsideACircle2)

        let settingsViewController = self.viewControllers?[1] as? SettingsViewController
        settingsViewController?.settingsViewModel = settingsViewModel
        settingsViewModel.delegate = settingsViewController
        settingsViewController?.tabBarItem.image = UIImage(asset: Asset.gear)

    }
}
