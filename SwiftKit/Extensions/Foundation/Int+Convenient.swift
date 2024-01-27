//
//  Int+Convenient.swift
//  TikTrends
//
//  Created by quanhua peng on 2024/1/22.
//

import Foundation

extension Int {
    var formattedRepresentation: String {
        let absValue = abs(self)
        switch absValue {
        case 0..<1_000:
            return "\(self)"
        case 1_000..<1_000_000:
            let kValue = Double(self) / 1_000.0
            return String(format: absValue % 1_000 == 0 ? "%.0fk" : "%.1fk", kValue)
        case 1_000_000..<1_000_000_000:
            let mValue = Double(self) / 1_000_000.0
            return String(format: absValue % 1_000_000 == 0 ? "%.0fM" : "%.1fM", mValue)
        default:
            let bValue = Double(self) / 1_000_000_000.0
            return String(format: absValue % 1_000_000_000 == 0 ? "%.0fB" : "%.1fB", bValue)
        }
    }
}
