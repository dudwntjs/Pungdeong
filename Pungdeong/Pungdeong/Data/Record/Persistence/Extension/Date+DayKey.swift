//
//  Date+DayKey.swift
//  Pungdeong
//
//  Created by sun on 4/18/26.
//

import Foundation

extension Date {

    var dayKey: String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    var startOfDayValue: Date {
        Calendar.current.startOfDay(for: self)
    }
}
