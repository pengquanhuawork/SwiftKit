//
//  SKColor.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/2/29.
//

import Foundation
import UIKit

public protocol SKColorProtocol {
    static var theme: UIColor { get set } // 主题色
    static var secondary: UIColor { get set } // 第2主题色
    static var text: UIColor { get set } // 普通文字颜色
    static var lightText: UIColor { get set } // 描述文字颜色
    static var placeholder: UIColor { get set } // 占位符颜色
    static var separator: UIColor { get set } // 分割线
    static var background: UIColor { get set } // 背景颜色
}
