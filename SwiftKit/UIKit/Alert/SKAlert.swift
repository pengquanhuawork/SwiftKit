//
//  SKAlert.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/18.
//

import Foundation
import UIKit

public class SKAlert {
    
    static public func showAlert(title: String,
                                 message: String,
                                 confirmTitle: String = "确定",
                                 cancelTitle: String = "取消",
                                 confirmAction: @escaping () -> Void,
                                 cancelAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsAlertAction = UIAlertAction(title: confirmTitle, style: .default) { (_) in
            confirmAction()
        }
        alertController.addAction(settingsAlertAction)
        
        let cancelAlertAction = UIAlertAction(title: cancelTitle, style: .cancel) { (_) in
            cancelAction?()
        }
        alertController.addAction(cancelAlertAction)
        
        BTDResponder.topViewController()?.present(alertController, animated: true, completion: nil)
    }
}
