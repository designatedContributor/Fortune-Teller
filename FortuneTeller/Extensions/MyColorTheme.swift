//
//  MyColorTheme.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/20/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

extension UIColor {
    
    struct MyColorTheme {
        static var Affirmative: UIColor { return UIColor(red: 120/255, green: 254/255, blue: 126/255, alpha: 1) }
        static var Neutral: UIColor { return UIColor(red: 113/255, green: 225/255, blue: 255/255, alpha: 1) }
        static var Contrary: UIColor { return UIColor(red: 255/255, green: 204/255, blue: 203/255, alpha: 1) }
        static var NeutralText: UIColor { return UIColor(red: 39/255, green: 128/255, blue: 255/255, alpha: 1) }
        static var AffirmativeText: UIColor { return UIColor(red: 14/255, green: 162/255, blue: 0, alpha: 1) }
    }
}
