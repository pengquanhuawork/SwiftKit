//
//  Date+Convenient.swift
//  TikTrends
//
//  Created by quanhua peng on 2024/1/23.
//

import Foundation

public extension Date {
    func sk_toString(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

