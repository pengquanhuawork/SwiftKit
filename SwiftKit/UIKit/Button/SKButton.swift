//
//  SKButton.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/7.
//

import UIKit

open class SKButton: UIButton {
    
    public var insetStyle: BTDButtonEdgeInsetsStyle?
    public var imageTitlespace: CGFloat = 0
    

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if let insetStyle = insetStyle {
            btd_layoutButton(with: insetStyle, imageTitlespace: imageTitlespace)
        }
    }
}
