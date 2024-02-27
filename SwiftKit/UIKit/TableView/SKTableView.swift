//
//  SKTableView.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/2/23.
//

import UIKit

open class SKTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        contentInsetAdjustmentBehavior = .never
        backgroundColor = .clear
        cellLayoutMarginsFollowReadableWidth = false
        keyboardDismissMode = .onDrag
        separatorStyle = .none
        separatorColor = .clear
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableHeaderView = UIView(frame: frame)
        tableFooterView = UIView(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
