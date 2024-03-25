//
//  Defaults+Extension.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/11.
//

import Foundation
import Defaults

public extension Defaults {
    static func updateWithTask<T>(_ key: Defaults.Key<T>, updateBlock: @escaping (T) -> Void) {
        updateBlock(Defaults[key])
        
        Task {
            for await _ in Defaults.updates(key) {
                DispatchQueue.main.async {
                    updateBlock(Defaults[key])
                }
            }
        }
    }
}
