//
//  SKScrollContainerView.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/15.
//

import UIKit

public class SKScrollContainerView: UIView {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        addSubview(scrollView)
        scrollView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(ScreenWidth)
        }
    }
    
    public func sk_addSubview(_ subview: UIView) {
        contentView.addSubview(subview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
