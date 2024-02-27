//
//  SKTableViewCell.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/2/23.
//

import UIKit

open class SKTableViewCell: UITableViewCell {

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupSubviews() {
        self.selectionStyle = .none
        self.backgroundView?.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }
}
