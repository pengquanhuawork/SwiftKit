//
//  UITableView+Convenient.swift
//  TikTrends
//
//  Created by quanhua peng on 2024/1/15.
//

import Foundation
import UIKit

public extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public extension UITableViewHeaderFooterView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public extension UITableView {
    
    // MARK: - Cell
    
    final func register<T: UITableViewCell>(cellType: T.Type) {
        self.register(cellType, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(T.reuseIdentifier) matching type \(T.self). Ensure you have registered the cell.")
        }
        return cell
    }
    
    // MARK: - Header & Footer
    
    final func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type) {
        self.register(headerFooterViewType, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    final func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type = T.self) -> T? {
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Failed to dequeue a header/footer with identifier \(T.reuseIdentifier) matching type \(T.self). Ensure you have registered the header/footer.")
        }
        return view
    }
}

