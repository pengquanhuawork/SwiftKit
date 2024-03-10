//
//  SKTableView.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/2/23.
//

import UIKit

public struct TableSectionData {
    public var datas: [Any] = []
    public init(datas: [Any]) {
        self.datas = datas
    }
}

open class SKTableView: UITableView {
    
    var cellType: SKTableViewCell.Type?
    public weak var cellDelegate: SKTableViewCellDelegate?
    
    public var sectionsDatas: [TableSectionData] = [] {
        didSet {
            reloadData()
        }
    }
    
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        dataSource = self
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
    
    final public func register<T: SKTableViewCell>(_ cellType: T.Type = T.self) {
        self.cellType = cellType
        register(cellType: cellType)
    }
}

extension SKTableView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsDatas.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = sectionsDatas[guard: section]
        return sectionData?.datas.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = self.cellType else { fatalError() }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as! SKTableViewCell
        cell.delegate = cellDelegate
        let items = sectionsDatas[guard: indexPath.section]?.datas
        cell.data = items?[guard: indexPath.row]
        return cell
    }
}
