//
//  UITextView+MaxCount.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/3.
//

import Foundation
import UIKit

private var characterCountKey: UInt8 = 0
private var characterCountChangedBlockKey: UInt8 = 0

public extension UITextView {
    
    var maxCharacterCount: Int? {
        get {
            return objc_getAssociatedObject(self, &characterCountKey) as? Int
        }
        set {
            objc_setAssociatedObject(self, &characterCountKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
        }
    }
    
    var characterCountChangedBlock: ((Int) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &characterCountChangedBlockKey) as? (Int) -> Void
        }
        set {
            objc_setAssociatedObject(self, &characterCountChangedBlockKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func textDidChange() {
        guard let maxCharacterCount = maxCharacterCount else { return }
        let currentCount = text.count

        if currentCount > maxCharacterCount {
            let newText = String(text.prefix(maxCharacterCount))
            text = newText
        }

        characterCountChangedBlock?(currentCount)
    }
}
