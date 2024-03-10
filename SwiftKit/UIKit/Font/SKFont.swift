//
//  SKFont.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/2.
//

import UIKit

public func printFontName() {
    for familyName in UIFont.familyNames {
        print("familyName: '\(familyName)'")
        
        for fontName in UIFont.fontNames(forFamilyName: familyName) {
            print("  fontName: '\(fontName)'")
        }
        
        print("***********")
    }
}

public protocol SKFontProtocol {

    static func bold(size: CGFloat) -> UIFont
    static func regular(size: CGFloat) -> UIFont
    static func medium(size: CGFloat) -> UIFont
}
