//
//  Date+Print.swift
//  GoatWeatherApp
//
//  Created by 景悦诚 on 2022/3/8.
//

import Foundation

extension Date {
    
    static func weekday(timeZone: String?, date: Date) -> String {
        var calendar = Calendar.init(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        if let timeZone = timeZone {
            if let tz = TimeZone.init(identifier: timeZone) {
                calendar.timeZone = tz
                dateFormatter.timeZone = tz
            }
        }
        if calendar.isDateInToday(date) {
            return "Today"
        }
        return dateFormatter.string(from: date)
    }
    
    static func dateString(timeZone: String?, date: Date) -> String {
        let dateFormatter = DateFormatter()
        if let timeZone = timeZone {
            if let tz = TimeZone.init(identifier: timeZone) {
                dateFormatter.timeZone = tz
            }
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
}
