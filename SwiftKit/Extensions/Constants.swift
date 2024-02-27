//
//  Constants.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/2/13.
//

import Foundation
import UIKit

public let ScreenWidth = UIScreen.main.bounds.size.width
public let ScreenHeight = UIScreen.main.bounds.size.height
public let StatusBarHeight = UIApplication.shared.statusBarFrame.height
public let ScreenRadio: CGFloat = ScreenWidth / 375
public var SafeInsetBottom: CGFloat {
    return KeyWindow?.safeAreaInsets.bottom ?? 0;
}
public var NavBarHeight: CGFloat = {
    return StatusBarHeight + 44
}()
public var KeyWindow: UIView? = {
    return UIApplication.shared.windows.first(where: { $0.isKeyWindow });
}()

//+ (CGFloat)fd_statusBarHeight {
//    if (@available(iOS 13.0, *)) {
//        NSSet *set = [UIApplication sharedApplication].connectedScenes;
//        UIWindowScene *windowScene = [set anyObject];
//        UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
//        return statusBarManager.statusBarFrame.size.height;
//    } else {
//        return [UIApplication sharedApplication].statusBarFrame.size.height;
//    }
//}
