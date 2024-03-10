//
//  SKCollectionViewCell.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/2.
//

import UIKit

public protocol SKCollectionViewCellDelegate: AnyObject {
    
}

open class SKCollectionViewCell: UICollectionViewCell {
    open var data: Any?
    public var delegate: SKCollectionViewCellDelegate?
}
