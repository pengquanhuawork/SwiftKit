//
//  SKShare.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/17.
//

import Foundation
import UIKit

public class SKShare {

    public static func shareApp(with title:String, appId: String, imageName: String) {

        guard let imageToShare = UIImage(named: imageName) else {
            return
        }
        // 分享的 URL
        guard let urlToShare = URL(string: "https://apps.apple.com/cn/app/id\(appId)") else {
            return
        }
        
        let activityItems: [Any] = [title, imageToShare, urlToShare]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.excludedActivityTypes = [
            .print,
            .addToReadingList,
            .openInIBooks,
            .assignToContact
        ]
        
        BTDResponder.topViewController()?.present(activityVC, animated: true)
    }
    
    public static func ratingApp(appId: String) {

        guard let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appId)") else {
            return
        }
        UIApplication.shared.open(url, options: [:]) { success in
            // 在此处处理打开 URL 的结果
        }
    }
}
