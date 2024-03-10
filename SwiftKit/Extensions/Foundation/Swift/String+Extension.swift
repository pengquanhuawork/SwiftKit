//
//  String+Convenient.swift
//  TikTrends
//
//  Created by quanhua peng on 2024/1/15.
//

import Foundation
import UIKit

public extension String {
    
    var sk_json: [String: Any]? {
        do {
            if self.isEmpty {
                return [:]
            } else if let jsonData = self.data(using: .utf8, allowLossyConversion: false),
                let dict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
                return dict
            }
        } catch {
            assert(false, error.localizedDescription)
        }
        return nil
    }
    
    
    
    func sk_array<T>() -> [T]? {
        do {
            if let jsonData = self.data(using: .utf8, allowLossyConversion: false),
                let array = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [T] {
                return array
            }
        } catch {
            assert(false, error.localizedDescription)
        }
        return nil
    }
}

// 计算字符串高、宽
public extension String {

    func sk_boundingRect(with size: CGSize, options: NSStringDrawingOptions, attributes: [NSAttributedString.Key: Any]?) -> CGRect {
        return (self as NSString).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }

    func sk_height(with font: UIFont, maxWidth: CGFloat) -> CGFloat {
        return sk_size(with: font, maxWidth: maxWidth).height
    }

    func sk_width(with font: UIFont, maxHeight: CGFloat) -> CGFloat {
        let rect = sk_boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: maxHeight),
                                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                                    attributes: [NSAttributedString.Key.font: font])
        let width = ceil(rect.size.width)
        return width
    }

    func sk_size(with font: UIFont, maxWidth: CGFloat) -> CGSize {
        return sk_size(with: font, maxWidth: maxWidth, maxLine: 0)
    }

    func sk_size(with font: UIFont, maxWidth: CGFloat, maxLine: Int) -> CGSize {
        var style = NSMutableParagraphStyle()
        #if os(iOS)
        let lineHeight = font.lineHeight
        #else
        let lineHeight = NSLayoutManager().defaultLineHeight(for: font)
        #endif
        style.minimumLineHeight = lineHeight
        style.maximumLineHeight = lineHeight
        let maxHeight = maxLine > 0 ? CGFloat(maxLine) * lineHeight : CGFloat.greatestFiniteMagnitude
        let rect = sk_boundingRect(with: CGSize(width: maxWidth, height: maxHeight),
                                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                                    attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style])
        return CGSize(width: ceil(rect.size.width), height: ceil(rect.size.height))
    }
}

public extension String {
    
    func sk_matches(pattern: String) -> [NSTextCheckingResult] {
        do {
            let range = NSRange(location: 0, length: count)
            let expression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matchResults = expression.matches(in: self, options: .withTransparentBounds, range: range)
            return matchResults
        } catch {
//            debugLog(error)
        }
        return []
    }
    
    // 获取 URL 参数
    func sk_getUrlParam(for key: String) -> String? {
        let components = URLComponents(string: self)
        let firstMacth = components?.queryItems?.first(where: { $0.name == key })
        return firstMacth?.value
    }
}

// MARK: - 截取子串
public extension String {
    
    func sk_substring(between startString: String, and endString: String?, options: String.CompareOptions = .caseInsensitive) -> String? {
        let range = self.range(of: startString, options: options)
        if let startIndex = range?.upperBound {
            let string = String(self[startIndex...])
            if let endString = endString {
                let range = string.range(of: endString, options: .caseInsensitive)
                if let startIndex = range?.lowerBound {
                    return String(string[..<startIndex])
                }
            }
            return string
        }
        return nil
    }
    
    func sk_substring(prefix: String, options: String.CompareOptions = .caseInsensitive, containPrefix: Bool = true) -> String? {
        let range = self.range(of: prefix, options: options)
        if let startIndex = range?.upperBound {
            var resultString = String(self[startIndex...])
            if containPrefix {
                resultString = "\(prefix)\(resultString)"
            }
            return resultString
        }
        return nil
    }
    
    func sk_substring(suffix: String, options: String.CompareOptions = .caseInsensitive, containSuffix: Bool = false) -> String? {
        let range = self.range(of: suffix, options: options)
        if let startIndex = range?.lowerBound {
            var resultString = String(self[startIndex...])
            if containSuffix {
                resultString = "\(resultString)\(suffix)"
            }
            return resultString
        }
        return nil
    }
    
    func sk_splitFirst(_ split: String, options: String.CompareOptions = .caseInsensitive) -> [String] {
        let range = self.range(of: split, options: options)
        if let splitIndex = range?.lowerBound {
            let right = String(self[splitIndex...])
            let left = String(self[..<splitIndex])
            return [left, right]
        }
        return []
    }
    
    func sk_substring(from: Int) -> String? {
        guard count > from && from >= 0 else { return nil }
        let index = self.index(self.startIndex, offsetBy: from)
        return String(self[index...])
    }
    
    func sk_substring(to: Int) -> String? {
        guard count > to && to >= 0 else { return nil }
        let index = self.index(self.startIndex, offsetBy: to)
        return String(self[..<index])
    }
    
    func sk_substring(with range: Range<Int>) -> String? {
        guard count > range.lowerBound && range.lowerBound >= 0 else { return nil }
        guard count > range.upperBound && range.upperBound >= 0 else { return nil }
        let lower = self.index(self.startIndex, offsetBy: range.lowerBound)
        let upper = self.index(self.startIndex, offsetBy: range.upperBound)
        let range = Range(uncheckedBounds: (lower, upper))
        return String(self[range])
    }
    
    func sk_substring(_ lower: Int, _ upper: Int) -> String? {
        guard count > lower && lower >= 0 else { return nil }
        guard count > upper && upper >= 0 else { return nil }
        let lowerIndex = self.index(self.startIndex, offsetBy: lower)
        let upperIndex = self.index(lowerIndex, offsetBy: upper)
        let range = Range(uncheckedBounds: (lowerIndex, upperIndex))
        return String(self[range])
    }
}

extension String {
    /*
     *去掉首尾空格
     */
    var sk_removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉首尾空格 包括后面的换行 \n
     */
    var sk_removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉所有空格
     */
    var sk_removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
}

// URL
public extension String {
    var sk_urlEncoding: String {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? self
    }
}

public extension NSAttributedString {
    static func sk_truncationToken(_ token: String, color: UIColor, font: UIFont) -> NSAttributedString {
        NSAttributedString(string: token, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font])
    }
}

public extension String {
    func sk_addAttributeString(_ addAttributes: [NSAttributedString.Key : Any], for texts: [String]) -> NSAttributedString {
        let attributeStr = NSMutableAttributedString(string: self)
        let nsString = NSString(string: self)
        for text in texts {
            let range = nsString.range(of: text)
            attributeStr.addAttributes([NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue], range: range)
        }
        attributeStr.addAttributes(addAttributes, range: nsString.range(of: self))
        return attributeStr
    }
}

extension String {
    func sk_formatDateString(from inputFormat: String, to outputFormat: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat

        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = outputFormat
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
