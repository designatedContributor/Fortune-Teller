//
//  AppDelegate.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // swiftlint:disable line_length
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor(named: ColorName.background)
        window?.rootViewController = TabBarViewController()
        window?.makeKeyAndVisible()
        return true
    }
    //swiftlint:enable line_length
}
