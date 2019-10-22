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

        //Initializing Active Model
        let activityModel = AnswersModel(networkService: NetwotkingService(), savedAnswerService: StoredAnswerService(), keychainService: KeychainService())
        activityModel.loadSavedAnswers()

        //swiftlint:enable line_length

        //Initializing ViewModels
        let mainViewModel = MainViewModel(activityModel: activityModel)
        let settingsViewModel = SettingsViewModel(activityModel: activityModel)

        //Initilizing and setting up View Controllers
        let mainViewController = MainViewController()
        mainViewController.tabBarItem.image = Asset._8BallInsideACircle2.image
        mainViewController.navigationItem.title = L10n.main
        mainViewController.mainViewModel = mainViewModel
        mainViewModel.delegate = mainViewController

        let settingsViewController = SettingsViewController()
        settingsViewController.settingsViewModel = settingsViewModel
        settingsViewController.tabBarItem.image = Asset.gear.image
        settingsViewController.navigationItem.title = L10n.settings

        let tabBarControllers = [mainViewController, settingsViewController]
        let textAttributes = [NSAttributedString.Key.foregroundColor: ColorName.white.color]
        //Embedding navigation controller
        viewControllers = tabBarControllers.map {
            UINavigationController(rootViewController: $0)
        }

        tabBarControllers.forEach {
            $0.navigationController?.navigationBar.barTintColor = Asset.tabbar.color
            $0.navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
        tabBar.barTintColor = Asset.tabbar.color
    }
}
