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
    
    static public func sendEmail(recipient: String, subject: String, body: String) {
        if let emailURL = createEmailURL(subject: subject, body: body, to: [recipient]) {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        }
    }
    
    static func createEmailURL(subject: String, body: String, to: [String]) -> URL? {
       let recipients = to.joined(separator: ",")
       let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
       let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

       let urlString = "mailto:\(recipients)?subject=\(subjectEncoded)&body=\(bodyEncoded)"

       return URL(string: urlString)
   }
    
    static public func openMailAppDownloadPage() {
        let appStoreURLString = "https://apps.apple.com/app/apple-store/id1108187098"
        if let appStoreURL = URL(string: appStoreURLString) {
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
    }
}
