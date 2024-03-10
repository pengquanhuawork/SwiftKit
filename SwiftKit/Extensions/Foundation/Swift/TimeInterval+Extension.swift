//
//  TimeInterval+Convenient.swift
//  TikTrends
//
//  Created by quanhua peng on 2024/1/22.
//

import Foundation

public extension TimeInterval {
    func sk_date(withFormat format: String) -> String {
        let date = Date(timeIntervalSince1970: self / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
