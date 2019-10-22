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
        let storedAnswerService = StoredAnswerService()
        let activityModel = AnswersModel(networkService: NetwotkingService(), savedAnswerService: storedAnswerService, keychainService: KeychainService())
        let fetchResultController = FetchResultController(storedAnswerService: storedAnswerService)

        //Initializing ViewModels
        let mainViewModel = MainViewModel(activityModel: activityModel)
        let settingsViewModel = SettingsViewModel(activityModel: activityModel, fetchResultController: fetchResultController)
        //swiftlint:enable line_length

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

        settingsViewModel.settingsDelegate = settingsViewController

        let answerHistoryViewController = AnswerHistoryViewController()
        let item = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 1)
        answerHistoryViewController.tabBarItem = item

        let tabBarControllers = [mainViewController, settingsViewController, answerHistoryViewController]
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
