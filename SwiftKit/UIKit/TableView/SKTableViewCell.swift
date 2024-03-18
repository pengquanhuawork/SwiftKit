//
//  SKTableViewCell.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/2/23.
//

import UIKit

public protocol SKTableViewCellDelegate: AnyObject {
    
}

open class SKTableViewCell: UITableViewCell {
    
    public var delegate: SKTableViewCellDelegate?
    open var data: Any?
    public var separator: UIView?
    public var iconImageView: UIImageView?
    public var titleLabel: UILabel?
    public var subTitleLabel: UILabel?
    public var arrowImageView: UIImageView?

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
