//
//  UIColor+Convenient.swift
//  TikTrends
//
//  Created by quanhua peng on 2024/1/15.
//

import Foundation
import UIKit

// MARK: - UIColor 颜色值
public extension UIColor {
    
    func alpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
        self.init(r: r, g: g, b: b, p3R: r, p3G: g, p3B: b, a: a)
    }
    
    convenience init(r: Int, g: Int, b: Int, p3R: Int, p3G: Int, p3B: Int, a: CGFloat = 1.0) {
        let totalValue: Float = 255
        if #available(iOS 10.0, *) {
            self.init(displayP3Red: CGFloat(Float(p3R) / totalValue), green: CGFloat(Float(p3G) / totalValue), blue: CGFloat(Float(p3B) / totalValue), alpha: a)
        } else {
            self.init(red: CGFloat(Float(r) / totalValue), green: CGFloat(Float(g) / totalValue), blue: CGFloat(Float(b) / totalValue), alpha: a)
        }
    }
    
    // Random
    static var randomColor: UIColor {
        return UIColor(r: Int(arc4random_uniform(256)), g: Int(arc4random_uniform(256)), b: Int(arc4random_uniform(256)))
    }
    
    // Pure
    static func pureColor(_ pureValue: Int, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(r: pureValue, g: pureValue, b: pureValue)
    }
    
    convenience init(hex: String) {
        
        var str: String = hex.lowercased()
        var values: [Int] = [0, 0, 0]
        str = str.substring(prefix: "#", containPrefix: false) ?? str
        var radixStr: String = ""
        for (index, char) in str.enumerated() {
            let valueIndex: Int = index / 2
            if valueIndex < values.count {
                radixStr += "\(char)"
                if index % 2 == 1, let radixInt = Int(radixStr, radix: 16) {
                    values[valueIndex] = radixInt
                    radixStr = ""
                }
            }
        }
        self.init(r: values[0], g: values[1], b: values[2])
    }
    
    // Common
    static let backgroundColor = UIColor(hex: "#fefefe")
    static let separator = UIColor(hex: "#e6e6e6")
    static let title = UIColor.black
    static let subTitle = UIColor(hex: "#777777")

    // 平均色
    static let pureColor3 = { UIColor.pureColor(3) }()
    static let pureColor16 = { UIColor.pureColor(22) }()
    static let pureColor22 = { UIColor.pureColor(34) }()
    static let pureColor12 = { UIColor.pureColor(18) }()
    static let pureColor1C = { UIColor.pureColor(28) }()
    static let pureColor23 = { UIColor.pureColor(35) }()
    static let pureColor3A = { UIColor.pureColor(58) }()
    static let pureColor4A = { UIColor.pureColor(74) }()
    static let pureColor55 = { UIColor.pureColor(85) }()
    static let pureColor60 = { UIColor.pureColor(96) }()
    static let pureColor7D = { UIColor.pureColor(125) }()
    static let pureColor88 = { UIColor.pureColor(136) }()
    static let pureColor9B = { UIColor.pureColor(155) }()
    static let pureColorA0 = { UIColor.pureColor(160) }()
    static let pureColorA8 = { UIColor.pureColor(168) }()
    static let pureColorB5 = { UIColor.pureColor(181) }()
    static let pureColorC6 = { UIColor.pureColor(198) }()
    static let pureColorD8 = { UIColor.pureColor(216) }()
    static let pureColorDA = { UIColor.pureColor(218) }()
    static let pureColorE7 = { UIColor.pureColor(231) }()
    static let pureColorE8 = { UIColor.pureColor(232) }()
    static let pureColorEB = { UIColor.pureColor(235) }()
    static let pureColorF2 = { UIColor.pureColor(242) }()
    static let pureColorF4 = { UIColor.pureColor(244) }()
    static let pureColorF8 = { UIColor.pureColor(248) }()
    static let pureColorF9 = { UIColor.pureColor(249) }()
    static let pureColorFA = { UIColor.pureColor(250) }()

    // 透明色
    static let whiteColorA0 = { white.alpha(0.0) }()
    static let whiteColorA1 = { white.alpha(0.1) }()
    static let whiteColorA2 = { white.alpha(0.2) }()
    static let whiteColorA3 = { white.alpha(0.3) }()
    static let whiteColorA4 = { white.alpha(0.4) }()
    static let whiteColorA5 = { white.alpha(0.5) }()
    static let whiteColorA6 = { white.alpha(0.6) }()
    static let whiteColorA72 = { white.alpha(0.72) }()
    static let whiteColorA9 = { white.alpha(0.9) }()
    static let whiteColorA8 = { white.alpha(0.8) }()
    static let blackColorA0 = { black.alpha(0.0) }()
    static let blackColorA1 = { black.alpha(0.1) }()
    static let blackColorA2 = { black.alpha(0.2) }()
    static let blackColorA3 = { black.alpha(0.3) }()
    static let blackColorA4 = { black.alpha(0.4) }()
    static let blackColorA48 = { black.alpha(0.48) }()
    static let blackColorA5 = { black.alpha(0.5) }()
    static let blackColorA7 = { black.alpha(0.7) }()
    static let blackColorA6 = { black.alpha(0.6) }()
    static let blackColorA8 = { black.alpha(0.8) }()
    static let blackColorA9 = { black.alpha(0.9) }()
    static let blackColorB5 = { black.alpha(0.05) }()
}
