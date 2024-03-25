//
//  SKCollectionView.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/1.
//

import UIKit

open class SKCollectionView: UICollectionView {
    
    var cellType: SKCollectionViewCell.Type?
    public weak var cellDelegate: SKCollectionViewCellDelegate?
    public var selectedIndexPath: IndexPath?
    
    public var datas: [Any] = [] {
        didSet {
            reloadData()
        }
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupSubviews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupSubviews() {
        contentInsetAdjustmentBehavior = .never
        backgroundColor = .clear
        keyboardDismissMode = .onDrag
        dataSource = self
        delegate = self
        showsHorizontalScrollIndicator = false
    }
    
    final public func register<T: SKCollectionViewCell>(_ cellType: T.Type = T.self) {
        self.cellType = cellType
        register(cellType: cellType)
    }
}

extension SKCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellType = self.cellType else { fatalError() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as! SKCollectionViewCell
        
        if let selectedIndexPath = self.selectedIndexPath {
            let selected = (indexPath.item == selectedIndexPath.item && indexPath.section == selectedIndexPath.section)
            cell.isSelected = selected
        }
        cell.delegate = cellDelegate
        cell.data = datas[indexPath.item]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
