//
//  UIButton+Extension.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/2/29.
//

import UIKit

public extension UIButton {
    
    func setImageName(_ name: String, for state: UIControl.State = .normal) {
        setImage(UIImage(named: name), for: state)
    }
    
    func setSystemImageName(_ name: String, for state: UIControl.State = .normal) {
        setImage(UIImage(systemName: name), for: state)
    }
    
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
    
    func setSelectedTitle(_ title: String) {
        setTitle(title, for: .selected)
    }
}
