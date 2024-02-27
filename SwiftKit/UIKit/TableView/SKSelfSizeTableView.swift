//
//  SKSelfSizeTableView.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/2/26.
//

import UIKit

/* 自动布局的 TableView，类似 UILabel、UIButton，
* 在使用 Auto Layout 时，只需提供位置，
* 系统会根据 intrinsicContentSize 来确定 SKSelfSizeTableView 的大小。
*/

open class SKSelfSizeTableView: SKTableView {

    var maxHeight: CGFloat = UIScreen.main.bounds.size.height - 200
    
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = false
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews()  {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    open override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
    
    open override var intrinsicContentSize: CGSize {
        let height = contentSize.height + contentInset.bottom + contentInset.top
        return CGSize(width: contentSize.width , height: height)
    }
}
