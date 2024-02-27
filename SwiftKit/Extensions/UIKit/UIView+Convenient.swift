//
//  UIView+Convenient.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/2/13.
//

import UIKit

public extension UIView {
    func sk_responderViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}

public extension UIView {
    
    /// The top coordinate of the UIView.
    var top: CGFloat {
        get {
            return frame.top
        }
        set(value) {
            var frame = self.frame
            frame.top = value
            self.frame = frame
        }
    }
    
    /// The left coordinate of the UIView.
    var left: CGFloat {
        get {
            return frame.left
        }
        set(value) {
            var frame = self.frame
            frame.left = value
            self.frame = frame
        }
    }
    
    /// The bottom coordinate of the UIView.
    var bottom: CGFloat {
        get {
            return frame.bottom
        }
        set(value) {
            var frame = self.frame
            frame.bottom = value
            self.frame = frame
        }
    }
    
    /// The right coordinate of the UIView.
    var right: CGFloat {
        get {
            return frame.right
        }
        set(value) {
            var frame = self.frame
            frame.right = value
            self.frame = frame
        }
    }
    
    // The width of the UIView.
    var width: CGFloat {
        get {
            return frame.width
        }
        set(value) {
            var frame = self.frame
            frame.width = value
            self.frame = frame
        }
    }
    
    var size: CGSize {
        get {
            return frame.size
        }
        set(value) {
            var frame = self.frame
            frame.size = value
            self.frame = frame
        }
    }
    
    // The height of the UIView.
    var height: CGFloat {
        get {
            return frame.height
        }
        set(value) {
            var frame = self.frame
            frame.height = value
            self.frame = frame
        }
    }
    
    /// The horizontal center coordinate of the UIView.
    var centerX: CGFloat {
        get {
            return frame.centerX
        }
        set(value) {
            var frame = self.frame
            frame.centerX = value
            self.frame = frame
        }
    }
    
    /// The vertical center coordinate of the UIView.
    var centerY: CGFloat {
        get {
            return frame.centerY
        }
        set(value) {
            var frame = self.frame
            frame.centerY = value
            self.frame = frame
        }
    }
    
    var absolutePoint: CGPoint {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let rect = self.convert(self.bounds, to: window)
            return rect.origin
        }
        return .zero
    }
}

// Extends CGRect with helper properties for positioning and setting dimensions
extension CGRect: ExpressibleByStringLiteral {
    
    /// The top coordinate of the rect.
    public var top: CGFloat {
        get {
            return origin.y
        }
        set(value) {
            origin.y = value
        }
    }
    
    // The left-side coordinate of the rect.
    public var left: CGFloat {
        get {
            return origin.x
        }
        set(value) {
            origin.x = value
        }
    }
    
    // The bottom coordinate of the rect. Setting this will change origin.y of the rect according to
    // the height of the rect.
    public var bottom: CGFloat {
        get {
            return origin.y + size.height
        }
        set(value) {
            origin.y = value - size.height
        }
    }
    
    // The right-side coordinate of the rect. Setting this will change origin.x of the rect according to
    // the width of the rect.
    public var right: CGFloat {
        get {
            return origin.x + size.width
        }
        set(value) {
            origin.x = value - size.width
        }
    }
    
    // The width of the rect.
    public var width: CGFloat {
        get {
            return size.width
        }
        set(value) {
            size.width = value
        }
    }
    
    // The height of the rect.
    public var height: CGFloat {
        get {
            return size.height
        }
        set(value) {
            size.height = value
        }
    }
    
    // The center x coordinate of the rect.
    public var centerX: CGFloat {
        get {
            return origin.x + size.width / 2
        }
        set (value) {
            origin.x = value - size.width / 2
        }
    }
    
    // The center y coordinate of the rect.
    public var centerY: CGFloat {
        get {
            return origin.y + size.height / 2
        }
        set (value) {
            origin.y = value - size.height / 2
        }
    }
    
    // The center of the rect.
    public var center: CGPoint {
        get {
            return CGPoint(x: centerX, y: centerY)
        }
        set (value) {
            centerX = value.x
            centerY = value.y
        }
    }
    
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    
    public init(stringLiteral value: StringLiteralType) {
        self.init()
        let rect: CGRect
        if value[value.startIndex] != "{" {
            let comp = value.components(separatedBy: ",")
            if comp.count == 4 {
                rect = NSCoder.cgRect(for: "{{\(comp[0]),\(comp[1])}, {\(comp[2]), \(comp[3])}}")
            } else {
                rect = CGRect.zero
            }
        } else {
            rect = NSCoder.cgRect(for: value)
        }
        
        self.size = rect.size
        self.origin = rect.origin
    }
    
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init(stringLiteral: value)
    }
    
    public typealias UnicodeScalarLiteralType = StringLiteralType
    
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init(stringLiteral: value)
    }
}

public extension UIView {
    
    func displayViewToImage(size: CGSize? = nil) -> UIImage? {
        // 生成截图
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        let imageSize = size ?? self.bounds.size
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

public extension UIView {
    
    // MARK: - 虚线
    
    func sk_drawDashedLine(in rect: CGRect) -> CAShapeLayer {
        let lineLayer = CAShapeLayer()
        lineLayer.frame = rect
        lineLayer.lineWidth = 1
        lineLayer.lineDashPattern = [3, 3]
        lineLayer.strokeColor = UIColor.pureColorDA.cgColor
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        lineLayer.path = path.cgPath
        self.layer.insertSublayer(lineLayer, at: 0)
        return lineLayer
    }
    
    // MARK: - 渐变
    
    enum UIViewFadeStyle {
        case bottom
        case top
        case left
        case right
        
        case vertical
        case horizontal
    }
    
    func sk_dropGradient(style: UIViewFadeStyle = .bottom, startColor: UIColor, endColor: UIColor, frame: CGRect? = nil) {
        let gradient = CAGradientLayer()
        gradient.frame = frame ?? bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
                
        switch style {
        case .bottom:
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 0, y: 1)
        case .top:
            gradient.startPoint = CGPoint(x: 0.5, y: 1)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        case .left:
            gradient.startPoint = CGPoint(x: 1, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .right:
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: - 阴影
    
    // 在列表内不要使用，会导致离屏渲染
    func sk_dropShadow(color: UIColor = .black, opacity: Float = 0.1, offSet: CGSize = .zero, radius: CGFloat = 5) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = .zero
        layer.shadowRadius = radius
    }

}
