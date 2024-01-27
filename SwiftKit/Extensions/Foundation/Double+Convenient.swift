//
//  Double+Convenient.swift
//  TikTrends
//
//  Created by quanhua peng on 2024/1/22.
//

import Foundation

extension Double {
    var formattedRepresentation: String {
        if self < 1000 {
            return String(format: "%.2f", self)
        } else if self < 10000 {
            let kValue = self / 1000.0
            return String(format: "%.2fk", kValue)
        } else if self < 1_000_000_000 {
            let mValue = self / 1_000_000.0
            return String(format: "%.2fM", mValue)
        } else {
            let bValue = self / 1_000_000_000.0
            return String(format: "%.2fB", bValue)
        }
    }
}
