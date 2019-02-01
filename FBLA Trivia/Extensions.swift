//
//  Extensions.swift
//  FBLA Trivia
//
//  Created by Tanner York on 1/31/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}

extension UIButton {

    func shoudlAdjustFontSizeAutomatically(_ bool: Bool) {
        if bool == false {
        } else {
            self.titleLabel?.minimumScaleFactor = 0.5
            self.titleLabel?.numberOfLines = 0
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
}
