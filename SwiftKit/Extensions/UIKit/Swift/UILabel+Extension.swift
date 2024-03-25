//
//  UILabel+Extension.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/3.
//

import Foundation
import UIKit

public extension UILabel {

    func sk_height(with maxWidth: CGFloat) -> CGFloat {
        return text?.sk_height(with: font, maxWidth: maxWidth) ?? 0
    }

    func sk_width(with maxHeight: CGFloat) -> CGFloat {
        return text?.sk_width(with: font, maxHeight: maxHeight) ?? 0
    }

    func sk_setText(_ text: String, lineHeight: CGFloat) {
        guard lineHeight > 0.01 || text.isEmpty else {
            self.text = text
            return
        }

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([.font: font as Any,
                                        .foregroundColor: textColor as Any],
                                       range: NSRange(location: 0, length: text.count))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = textAlignment
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.minimumLineHeight = lineHeight
        attributedString.addAttributes([.paragraphStyle: paragraphStyle],
                                       range: NSRange(location: 0, length: text.count))

        self.attributedText = attributedString
    }

    func sk_setText(_ originText: String, withNeedHighlightedText needHighlightText: String?, highlightedColor color: UIColor) {
        guard let needHighlightText = needHighlightText, originText.contains(needHighlightText) else {
            self.text = originText
            return
        }

        if let range = originText.range(of: needHighlightText) {
            let nsRange = NSRange(range, in: originText)
            let attributedString = NSMutableAttributedString(string: originText)
            attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
            self.attributedText = attributedString
        }
    }
    
    func addShadow() {
        let shadowOffset = CGSize(width: 0.5, height: 0.5)
        let shadowColor = UIColor.black
        let shadowBlurRadius: CGFloat = 1
        
        let shadow = NSShadow()
        shadow.shadowOffset = shadowOffset
        shadow.shadowColor = shadowColor
        shadow.shadowBlurRadius = shadowBlurRadius
        
        let attributedString = NSAttributedString(string: self.text ?? "", attributes: [
            NSAttributedString.Key.shadow: shadow
        ])
        
        self.attributedText = attributedString
    }
}
