//
//  Array+Convenient.swift
//  TikTrends
//
//  Created by quanhua peng on 2024/1/15.
//

import Foundation

public extension Array {
    
    func sk_safeIndex(_ i: Int) -> Array.Iterator.Element? {
        guard !isEmpty && i >= 0 && i < count else { return nil }
        return self[i]
    }
    
    subscript(guard idx: Int) -> Element? {
        guard (startIndex..<endIndex).contains(idx) else { return nil }
        return self[idx]
    }
    
    // 去重
    func sk_filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}
