//
//  Optional+Convenient.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/2/13.
//

import Foundation

public extension Optional where Wrapped == String {
    var sk_isNilOrEmpty: Bool {
        return ((self) ?? "").isEmpty
    }
}

public extension Optional {

    var sk_isEmpty: Bool {
    return self == nil
  }

  var sk_exists: Bool {
    return self != nil
  }
}
 
infix operator ???: NilCoalescingPrecedence
public func ???<T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    switch optional {
    case let value?: return String(describing: value)
    case nil: return defaultValue()
    }
}

infix operator !!
public func !!<T>(wrapped: T?, failureText: @autoclosure() -> String) -> T {
    if let x = wrapped { return x }
    fatalError(failureText())
}

infix operator !?
public func !?<T>(wrapped: T?, nilDefault: @autoclosure() -> (value: T, text: String)) -> T {
    assert(wrapped != nil, nilDefault().text)
    return wrapped ?? nilDefault().value
}

extension Optional {
    // 如果是非 `nil` 值，就对 `self` 解包。
    // 如果 `self` 是 `nil`，就抛出错误。
   public func sk_or(error: Error) throws -> Wrapped {
        switch self {
        case let x?: return x
        case nil: throw error
        }
    }
}

extension Optional where Wrapped == Bool {
    public func sk_value(default: Wrapped = false) -> Wrapped {
        return self ?? `default`
    }
}

extension Optional where Wrapped == Int {
    public func sk_value(default: Wrapped = 0) -> Wrapped {
        return self ?? `default`
    }
}

extension Optional where Wrapped == Double {
    public func sk_value(default: Wrapped = 0.0) -> Wrapped {
        return self ?? `default`
    }
}

extension Optional where Wrapped == Float {
    public func sk_value(default: Wrapped = 0.0) -> Wrapped {
        return self ?? `default`
    }
}

extension Optional where Wrapped == String {
    public func sk_value(default: Wrapped = "") -> Wrapped {
        guard let self = self else {
            return `default`
        }
        return self.isEmpty ? `default` : self
    }
}
