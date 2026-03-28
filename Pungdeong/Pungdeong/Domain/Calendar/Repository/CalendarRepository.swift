//
//  CalendarRepository.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import Foundation

protocol CalendarRepository {
    func makeMonthDate(from baseDate: Date, offset: Int) -> Date
    func fetchMonthDates(for monthDate: Date) -> [Date]
    func firstWeekday(for date: Date) -> Int
    func weekday(for date: Date) -> Int
    func dayNumber(for date: Date) -> Int
    func isToday(_ date: Date) -> Bool
    func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool
    func formatHeader(from date: Date) -> String
}
