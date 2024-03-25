//
//  Date+Convenient.swift
//  TikTrends
//
//  Created by quanhua peng on 2024/1/23.
//

import Foundation


private var _sk_OptimizeDateFormatterEnabled = true

public extension Date {

    var sk_year: Int {
        return Calendar.current.component(.year, from: self)
    }

    var sk_month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var sk_day: Int {
        return Calendar.current.component(.day, from: self)
    }

    var sk_weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var sk_weekdayStr: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_CN")
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }

    var sk_hour: Int {
        return Calendar.current.component(.hour, from: self)
    }

    var sk_minute: Int {
        return Calendar.current.component(.minute, from: self)
    }

    var sk_second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    var  sk_timeOfDay: String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        
        switch hour {
        case 0..<12:
            return "上午"
        case 12..<18:
            return "下午"
        default:
            return "晚上"
        }
    }

    func sk_isSameDay(as date: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: self)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date)
        return components1.day == components2.day && components1.month == components2.month && components1.year == components2.year
    }

    func sk_isEarlierThanDate(_ anotherDate: Date) -> Bool {
        return self.compare(anotherDate) == .orderedAscending
    }

    func sk_isLaterThanDate(_ anotherDate: Date) -> Bool {
        return self.compare(anotherDate) == .orderedDescending
    }

    func sk_dateByAddingYears(_ years: Int) -> Date? {
        return Calendar.current.date(byAdding: .year, value: years, to: self)
    }

    func sk_dateByAddingMonths(_ months: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: months, to: self)
    }

    func sk_dateByAddingWeeks(_ weeks: Int) -> Date? {
        return Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self)
    }

    func sk_dateByAddingDays(_ days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
    }

    func sk_dateByAddingHours(_ hours: Int) -> Date? {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)
    }

    func sk_dateByAddingMinutes(_ minutes: Int) -> Date? {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)
    }

    func sk_dateByAddingSeconds(_ seconds: Int) -> Date? {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self)
    }

    func sk_string(with format: String) -> String {
        return sk_string(with: format, timeZone: nil, locale: Locale.current)
    }
    
    func sk_daysBetweenNow() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: Date())
        
        if let days = components.day {
            return abs(days)
        } else {
            return 0
        }
    }

    func sk_string(with format: String, timeZone: TimeZone? = nil, locale: Locale) -> String {
        let formatter = Date.sk_OptimizeDateFormatterEnabled && Thread.isMainThread ? Date.DateFormatterForMainThread() : DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.string(from: self)
    }

    static func sk_date(with dateString: String, format: String) -> Date? {
        return sk_date(with: dateString, format: format, timeZone: nil, locale: nil)
    }

    static func sk_date(with dateString: String, format: String, timeZone: TimeZone?, locale: Locale?) -> Date? {
        let formatter = Date.sk_OptimizeDateFormatterEnabled && Thread.isMainThread ? Date.DateFormatterForMainThread() : DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.date(from: dateString)
    }

    static func sk_date(withYear year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date? {
        let formatString = "yyyy-MM-dd HH:mm:ss"
        let dateString = String(format: "%04d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second)
        return sk_date(with: dateString, format: formatString)
    }

    static func sk_daysInMonth(_ month: Int, year: Int) -> Int {
        let date = sk_date(withYear: year, month: month, day: 1, hour: 0, minute: 0, second: 0)
        let range = Calendar.current.range(of: .day, in: .month, for: date!)
        return range?.count ?? 0
    }

    static var sk_OptimizeDateFormatterEnabled: Bool {
        return _sk_OptimizeDateFormatterEnabled
    }

    static func setsk_OptimizeDateFormatterEnabled(_ isEnabled: Bool) {
        _sk_OptimizeDateFormatterEnabled = isEnabled
    }

    private static func DateFormatterForMainThread() -> DateFormatter {
        let formatter = DateFormatter()
        return formatter
    }

    private static func _ISO8601DateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }

    
}

func sk_currentMachTime() -> UInt64 {
    return mach_absolute_time()
}

func sk_machTimeToSecs(_ time: UInt64) -> Double {
    var timebase = mach_timebase_info_data_t()
    mach_timebase_info(&timebase)
    return Double(time) * Double(timebase.numer) / Double(timebase.denom) / Double(NSEC_PER_SEC)
}


