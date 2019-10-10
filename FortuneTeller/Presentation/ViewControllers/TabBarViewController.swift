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
// swiftlint:disable line_length
        let activityModel = AnswersModel(networkService: NetwotkingService(), userDefaultAnswer: UserDefaultService(), keychainService: KeychainService())
//swiftlint:enable line_length
        activityModel.loadSavedAnswers()

        let mainViewModel = MainViewModel(activityModel: activityModel)
        let settingsViewModel = SettingsViewModel(activityModel: activityModel)
        let mainViewController = MainViewController()
        mainViewController.tabBarItem.image = UIImage(asset: Asset._8BallInsideACircle2)

        mainViewController.mainViewModel = mainViewModel
        mainViewModel.delegate = mainViewController

        let settingsViewController = SettingsViewController()
        settingsViewController.settingsViewModel = settingsViewModel
        settingsViewModel.delegate = settingsViewController
        settingsViewController.tabBarItem.image = UIImage(asset: Asset.gear)

        let tabBarList = [mainViewController, settingsViewController]
        viewControllers = tabBarList
        tabBar.barTintColor = UIColor(named: ColorName.tabbar)
    }
}
