//
//  Data+Convenient.swift
//  TikTrends
//
//  Created by quanhua peng on 2024/1/10.
//

import Foundation

public extension Data {
    
    func sk_decoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
    
    func sk_dictionary() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
