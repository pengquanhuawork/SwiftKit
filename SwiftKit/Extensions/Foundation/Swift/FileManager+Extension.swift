//
//  FileManager+Extension.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/3.
//

import Foundation

extension FileManager {

    static var sk_cachePath: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    }

    static var sk_documentPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }

    static var sk_libraryPath: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
    }

    static var sk_mainBundlePath: String {
        return Bundle.main.bundlePath
    }

    static func sk_fileSize(atPath filePath: String) -> Int64 {
        let manager = FileManager.default
        if manager.fileExists(atPath: filePath) {
            do {
                let attributes = try manager.attributesOfItem(atPath: filePath)
                if let fileSize = attributes[.size] as? Int64 {
                    return fileSize
                }
            } catch {
                // Handle error
            }
        }
        return 0
    }

    static func sk_folderSize(atPath folderPath: String) -> Int64 {
        let manager = FileManager.default
        guard manager.fileExists(atPath: folderPath) else {
            return 0
        }

        var folderSize: Int64 = 0

        autoreleasepool {
            let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsSubdirectoryDescendants]
            let folderURL = URL(fileURLWithPath: folderPath, isDirectory: true)
            if #available(iOS 13.0, *) {
                let fileEnumerator = manager.enumerator(at: folderURL, includingPropertiesForKeys: nil, options: options, errorHandler: nil)
                for case let fileURL as URL in fileEnumerator! {
                    autoreleasepool {
                        var isDirectory: ObjCBool = false
                        manager.fileExists(atPath: fileURL.path, isDirectory: &isDirectory)

                        var fileSize: Int64 = 0
                        if isDirectory.boolValue {
                            fileSize = sk_folderSize(atPath: fileURL.path)
                        } else {
                            do {
                                let attributes = try manager.attributesOfItem(atPath: fileURL.path)
                                if let fileSizeNumber = attributes[.size] as? NSNumber {
                                    fileSize = fileSizeNumber.int64Value
                                }
                            } catch {
                                // Handle error
                            }
                        }

                        folderSize += fileSize
                    }
                }
            }
        }

        return folderSize
    }

    static func sk_printFolderDetailSize(atPath folderPath: String) {
        let manager = FileManager.default
        guard manager.fileExists(atPath: folderPath) else {
            return
        }

        if let contentArray = try? manager.contentsOfDirectory(atPath: folderPath) {
            for obj in contentArray {
                let absolutePath = (folderPath as NSString).appendingPathComponent(obj)
                var isDirectory: ObjCBool = false
                manager.fileExists(atPath: absolutePath, isDirectory: &isDirectory)

                var fileSize: Int64 = 0
                if isDirectory.boolValue {
                    fileSize = sk_folderSize(atPath: absolutePath)
                } else {
                    fileSize = sk_fileSize(atPath: absolutePath)
                }

                print("FOLDER DETAIL \(obj), \(String(format: "%.2fK", Float(fileSize) / 1024))")
            }
        }
    }

    static func sk_clearFolder(atPath folderPath: String) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: folderPath) {
            do {
                let childFiles = try fileManager.subpathsOfDirectory(atPath: folderPath)
                for fileName in childFiles {
                    let absolutePath = (folderPath as NSString).appendingPathComponent(fileName)
                    try fileManager.removeItem(atPath: absolutePath)
                }
            } catch {
                // Handle error
            }
        }
    }

    
}
