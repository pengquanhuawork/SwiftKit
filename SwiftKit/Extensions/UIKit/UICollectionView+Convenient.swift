//
//  UICollectionView+Convenient.swift
//  TikTrends
//
//  Created by quanhua peng on 2024/1/15.
//

import Foundation
import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    
    // MARK: - Cell
    
    final func register<T: UICollectionViewCell>(cellType: T.Type = T.self) {
        self.register(cellType, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        let bareCell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath)
        guard let cell = bareCell as? T else {
          fatalError("Failed to dequeue a cell with identifier \(T.reuseIdentifier) matching type \(T.self). Ensure you have registered the cell.")
        }
        return cell
    }
    
    // MARK: - SupplementaryView
    
    final func register<T: UICollectionReusableView>(supplementaryViewType: T.Type, ofKind elementKind: String) {
        self.register(supplementaryViewType, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    final func dequeueReusableSupplementaryView<T: UICollectionReusableView>
      (ofKind elementKind: String, for indexPath: IndexPath, viewType: T.Type = T.self) -> T {
        let view = self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath)
        guard let typedView = view as? T else {
          fatalError("Failed to dequeue a supplementary view with identifier \(T.reuseIdentifier) matching type \(T.self). Ensure you have registered the supplementary view.")
        }
        return typedView
    }
}

