//
//  DefaultCalendarRepository.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import Foundation

final class DefaultCalendarRepository: CalendarRepository {
    private let calendarService: CalendarService
    private let formatterService: CalendarFormatterService

    init(
        calendarService: CalendarService = DefaultCalendarService(),
        formatterService: CalendarFormatterService = DefaultCalendarFormatterService()
    ) {
        self.calendarService = calendarService
        self.formatterService = formatterService
    }

    func makeMonthDate(from baseDate: Date, offset: Int) -> Date {
        calendarService.makeMonthDate(from: baseDate, offset: offset)
    }

    func fetchMonthDates(for monthDate: Date) -> [Date] {
        calendarService.monthDates(for: monthDate)
    }

    func firstWeekday(for date: Date) -> Int {
        calendarService.firstWeekday(for: date)
    }

    func weekday(for date: Date) -> Int {
        calendarService.weekday(for: date)
    }

    func dayNumber(for date: Date) -> Int {
        calendarService.dayNumber(for: date)
    }

    func isToday(_ date: Date) -> Bool {
        calendarService.isToday(date)
    }

    func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool {
        calendarService.isSameDay(lhs, rhs)
    }

    func formatHeader(from date: Date) -> String {
        formatterService.headerString(from: date)
    }
}
