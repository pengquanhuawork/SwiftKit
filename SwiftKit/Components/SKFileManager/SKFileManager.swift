//
//  SKFileManager.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/19.
//

import Foundation

public class SKFileManager {
    
    public static func clearTemporaryDirectory(completion: @escaping (Error?) -> Void) {
        let fileManager = FileManager.default
        let temporaryDirectory = NSTemporaryDirectory()
        
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: temporaryDirectory)
            
            for file in contents {
                let filePath = temporaryDirectory + file
                try fileManager.removeItem(atPath: filePath)
            }
            
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    public static func clearCacheDirectory(completion: @escaping (Error?) -> Void) {
            let fileManager = FileManager.default
            
            // 获取Cache目录路径
            if let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
                do {
                    let contents = try fileManager.contentsOfDirectory(atPath: cacheDirectory)
                    
                    for file in contents {
                        let filePath = (cacheDirectory as NSString).appendingPathComponent(file)
                        try fileManager.removeItem(atPath: filePath)
                    }
                    
                    completion(nil) // 清理成功
                } catch {
                    completion(error) // 清理过程中出现错误
                }
            }
        }
}
