//
//  NotificationCenter+Convenient.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/2/26.
//

import Foundation

public extension NotificationCenter {
    func sk_addObserver(forName name: NSNotification.Name?, using block: @escaping (Notification) -> Void) {
        addObserver(forName: name, object: nil, queue: OperationQueue.main, using: block)
    }
    
    func sk_post(name aName: NSNotification.Name, userInfo aUserInfo: [AnyHashable : Any]? = nil) {
        post(name: aName, object: nil, userInfo: aUserInfo)
    }
}
