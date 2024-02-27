//
//  SKView.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/2/23.
//

import UIKit

open class SKView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupSubviews() {
        
    }
}
