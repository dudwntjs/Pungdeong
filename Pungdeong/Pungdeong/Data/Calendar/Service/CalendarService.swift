//
//  CalendarService.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import Foundation

protocol CalendarService {
    func makeMonthDate(from baseDate: Date, offset: Int) -> Date
    func monthDates(for monthDate: Date) -> [Date]
    func firstWeekday(for date: Date) -> Int
    func weekday(for date: Date) -> Int
    func dayNumber(for date: Date) -> Int
    func isToday(_ date: Date) -> Bool
    func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool
}

final class DefaultCalendarService: CalendarService {
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func makeMonthDate(from baseDate: Date, offset: Int) -> Date {
        calendar.date(byAdding: .month, value: offset, to: baseDate) ?? baseDate
    }

    func monthDates(for monthDate: Date) -> [Date] {
        guard
            let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate)),
            let range = calendar.range(of: .day, in: .month, for: startDate)
        else {
            return []
        }

        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startDate)
        }
    }

    func firstWeekday(for date: Date) -> Int {
        calendar.component(.weekday, from: date)
    }

    func weekday(for date: Date) -> Int {
        calendar.component(.weekday, from: date)
    }

    func dayNumber(for date: Date) -> Int {
        calendar.component(.day, from: date)
    }

    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool {
        calendar.isDate(lhs, inSameDayAs: rhs)
    }
}
