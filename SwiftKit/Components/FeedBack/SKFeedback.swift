//
//  FeedBack.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/17.
//

import Foundation
import UIKit

public class SKFeedback {
    static public func isMailAppInstalled() -> Bool {
        guard let emailURL = URL(string: "mailto:") else {
            return false
        }
        
        return UIApplication.shared.canOpenURL(emailURL)
    }
    
    static public func sendEmail(recipient: String, subject: String) {
        if let emailURL = URL(string: "mailto:\(recipient)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        }
    }
    
    static public func openMailAppDownloadPage() {
        let appStoreURLString = "https://apps.apple.com/app/apple-store/id1108187098"
        if let appStoreURL = URL(string: appStoreURLString) {
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
    }
}
