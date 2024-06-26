//
//  Dictionary+Convenient.swift
//  TikTrends
//
//  Created by quanhua peng on 2024/1/10.
//

import Foundation

public extension NSDictionary {
    func sk_getBool(_ keys: String..., defaultValue: Bool = false) -> Bool {
        for key in keys {
            if let result = self[key] as? Bool {
                return result
            }
        }
        return defaultValue
    }

    func sk_getDouble(_ keys: String..., defaultValue: Double = 0.0, minValue: Double? = nil, maxValue: Double? = nil) -> Double {
        for key in keys {
            if var result = self[key] as? Double {
                if let minValue = minValue {
                    result = Swift.max(minValue, result)
                }
                if let maxValue = maxValue {
                    result = Swift.min(maxValue, result)
                }
                return result
            }
        }
        return defaultValue
    }

    func sk_getInt(_ keys: String..., defaultValue: Int = 0, minValue: Int? = nil, maxValue: Int? = nil) -> Int {
        for key in keys {
            if var result = self[key] as? Int {
                if let minValue = minValue {
                    result = Swift.max(minValue, result)
                }
                if let maxValue = maxValue {
                    result = Swift.min(maxValue, result)
                }
                return result
            }
        }
        return defaultValue
    }

    func sk_getInt64(_ keys: String..., defaultValue: Int64 = 0, minValue: Int64? = nil, maxValue: Int64? = nil) -> Int64 {
        for key in keys {
            if var result = self[key] as? Int64 {
                if let minValue = minValue {
                    result = Swift.max(minValue, result)
                }
                if let maxValue = maxValue {
                    result = Swift.min(maxValue, result)
                }
                return result
            }
        }
        return defaultValue
    }

    func sk_getString(_ keys: String..., defaultValue: String? = nil) -> String? {
        for key in keys {
            if let result = self[key] as? String {
                return result
            }
        }
        return defaultValue
    }

    func sk_getDict(_ keys: String..., defaultValue: NSDictionary? = nil) -> NSDictionary? {
        for key in keys {
            if let result = self[key] as? NSDictionary {
                return result
            }
        }
        return defaultValue
    }

    func sk_getArray<T>(_ keys: String..., type: T.Type) -> [T] {
        for key in keys {
            if let result = self[key] as? [T] {
                return result
            }
        }
        return []
    }

    var sk_toJsonString: String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        return "{}"
    }
}

extension Dictionary where Key == String {

    func sk_getBool(_ keys: String..., defaultValue: Bool = false) -> Bool {
        for key in keys {
            if let result = self[key] as? Bool {
                return result
            }
        }
        return defaultValue
    }

    func sk_getDouble(_ keys: String..., defaultValue: Double = 0.0, minValue: Double? = nil, maxValue: Double? = nil) -> Double {
        for key in keys {
            if var result = self[key] as? Double {
                if let minValue = minValue {
                    result = Swift.max(minValue, result)
                }
                if let maxValue = maxValue {
                    result = Swift.min(maxValue, result)
                }
                return result
            } else if let resultStr = self[key] as? String, var result = Double(resultStr) {
                if let minValue = minValue {
                    result = Swift.max(minValue, result)
                }
                if let maxValue = maxValue {
                    result = Swift.min(maxValue, result)
                }
                return result
            }
        }
        return defaultValue
    }

    func sk_getInt(_ keys: String..., defaultValue: Int = 0, minValue: Int? = nil, maxValue: Int? = nil) -> Int {
        for key in keys {
            if var result = self[key] as? Int {
                if let minValue = minValue {
                    result = Swift.max(minValue, result)
                }
                if let maxValue = maxValue {
                    result = Swift.min(maxValue, result)
                }
                return result
            } else if let resultStr = self[key] as? String, var result = Int(resultStr) {
                if let minValue = minValue {
                    result = Swift.max(minValue, result)
                }
                if let maxValue = maxValue {
                    result = Swift.min(maxValue, result)
                }
                return result
            }
        }
        return defaultValue
    }

    func sk_getInt64(_ keys: String..., defaultValue: Int64 = 0, minValue: Int64? = nil, maxValue: Int64? = nil) -> Int64 {
        for key in keys {
            if var result = self[key] as? Int64 {
                if let minValue = minValue {
                    result = Swift.max(minValue, result)
                }
                if let maxValue = maxValue {
                    result = Swift.min(maxValue, result)
                }
                return result
            } else if let resultStr = self[key] as? String, var result = Int64(resultStr) {
                if let minValue = minValue {
                    result = Swift.max(minValue, result)
                }
                if let maxValue = maxValue {
                    result = Swift.min(maxValue, result)
                }
                return result
            }
        }
        return defaultValue
    }

    func sk_getString(_ keys: String..., defaultValue: String? = nil) -> String? {
        for key in keys {
            if let result = self[key] as? String {
                return result
            } else if let result = self[key] as? Int {
                return String(result)
            } else if let result = self[key] as? Int64 {
                return String(result)
            }
        }
        return defaultValue
    }

    func sk_getDict(_ keys: String..., defaultValue: NSDictionary? = nil) -> NSDictionary? {
        for key in keys {
            if let result = self[key] as? NSDictionary {
                return result
            } else if let resultStr = self[key] as? String {
                let result = sk_convertStringToDictionary(text: resultStr)
                return result
            }
        }
        return defaultValue
    }

    func sk_getOptionalObject<T>(_ keys: String..., type: T.Type, defaultValue: T? = nil) -> T? {
        for key in keys {
            if let result = self[key] as? T {
                return result
            }
        }
        return defaultValue
    }

    func sk_getObject<T>(_ keys: String..., type: T.Type, defaultValue: T) -> T {
        for key in keys {
            if let result = self[key] as? T {
                return result
            }
        }
        return defaultValue
    }

    func sk_getArray<T>(_ keys: String..., type: T.Type) -> [T] {
        for key in keys {
            if let result = self[key] as? [T] {
                return result
            }
        }
        return []
    }

    /// Merges the dictionary with dictionaries passed. The latter dictionaries will override
    /// values of the keys that are already set
    ///
    /// :param dictionaries A comma seperated list of dictionaries
    mutating func merge<K, V>(_ dictionaries: Dictionary<K, V>...) {
        for dict in dictionaries {
            for (key, value) in dict {
                if let v = value as? Value, let k = key as? Key {
                    self.updateValue(v, forKey: k)
                }
            }
        }
    }

    var sk_jsonString: String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        return "{}"
    }

    func sk_convertStringToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
