////
////  UIApplication+Convenient.swift
////  iAuthenticator
////
////  Created by quanhua peng on 2024/5/20.
////
//
//import Foundation
//import UIKit
//
//extension UIViewController {
//    var topViewController: UIViewController {
//        if self.presentedViewController == nil {
//            return self
//        }
//        if let navigation = self.presentedViewController as? UINavigationController {
//            return navigation.visibleViewController!.topViewController
//        }
//        if let tab = self.presentedViewController as? UITabBarController {
//            if let selectedTab = tab.selectedViewController {
//                return selectedTab.topViewController
//            }
//            return tab.topViewController
//        }
//        return self.presentedViewController!.topViewController
//    }
//}
//
//extension UIApplication {
//    static var topViewController: UIViewController? {
//        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController?.topViewController
//    }
//}
