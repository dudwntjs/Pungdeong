//
//  GetCalendarDaysUseCase.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import Foundation

protocol GetCalendarDaysUseCase {
    func execute(
        baseDate: Date,
        offset: Int,
        selectedDate: Date?,
        levelProvider: (Date) -> PungdeongLevel?
    ) -> [CalendarDay]
}

final class DefaultGetCalendarDaysUseCase: GetCalendarDaysUseCase {
    private let repository: CalendarRepository
    private let calendar = Calendar.current

    init(repository: CalendarRepository) {
        self.repository = repository
    }

    func execute(
        baseDate: Date,
        offset: Int,
        selectedDate: Date?,
        levelProvider: (Date) -> PungdeongLevel?
    ) -> [CalendarDay] {
        let monthDate = repository.makeMonthDate(from: baseDate, offset: offset)
        let dates = repository.fetchMonthDates(for: monthDate)

        guard
            let firstDate = dates.first,
            let lastDate = dates.last
        else {
            return []
        }

        let normalizedSelectedDate = selectedDate.map { calendar.startOfDay(for: $0) }

        let firstWeekday = repository.firstWeekday(for: firstDate)
        let placeholderCount = max(0, firstWeekday - 1)

        let leadingPlaceholders: [CalendarDay] = (0..<placeholderCount).compactMap { index in
            let daysToSubtract = placeholderCount - index

            guard let rawDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: firstDate) else {
                return nil
            }

            let date = calendar.startOfDay(for: rawDate)
            let weekday = repository.weekday(for: date)

            return CalendarDay(
                number: repository.dayNumber(for: date),
                date: date,
                isToday: repository.isToday(date),
                isSunday: weekday == 1,
                isSaturday: weekday == 7,
                isSelected: normalizedSelectedDate.map { repository.isSameDay($0, date) } ?? false,
                level: nil,
                isPlaceholder: true,
                isFiller: false
            )
        }

        let realDays: [CalendarDay] = dates.map { rawDate in
            let date = calendar.startOfDay(for: rawDate)
            let weekday = repository.weekday(for: date)

            return CalendarDay(
                number: repository.dayNumber(for: date),
                date: date,
                isToday: repository.isToday(date),
                isSunday: weekday == 1,
                isSaturday: weekday == 7,
                isSelected: normalizedSelectedDate.map { repository.isSameDay($0, date) } ?? false,
                level: levelProvider(date),
                isPlaceholder: false,
                isFiller: false
            )
        }

        let currentCount = leadingPlaceholders.count + realDays.count
        let visibleTrailingCount = currentCount % 7 == 0 ? 0 : 7 - (currentCount % 7)

        let trailingPlaceholders: [CalendarDay] = (0..<visibleTrailingCount).compactMap { index in
            guard let rawDate = calendar.date(byAdding: .day, value: index + 1, to: lastDate) else {
                return nil
            }

            let date = calendar.startOfDay(for: rawDate)
            let weekday = repository.weekday(for: date)

            return CalendarDay(
                number: repository.dayNumber(for: date),
                date: date,
                isToday: repository.isToday(date),
                isSunday: weekday == 1,
                isSaturday: weekday == 7,
                isSelected: normalizedSelectedDate.map { repository.isSameDay($0, date) } ?? false,
                level: nil,
                isPlaceholder: true,
                isFiller: false
            )
        }

        let fillerCount = max(0, 42 - (currentCount + trailingPlaceholders.count))

        let fillers: [CalendarDay] = (0..<fillerCount).map { _ in
            CalendarDay(
                number: nil,
                date: nil,
                isToday: false,
                isSunday: false,
                isSaturday: false,
                isSelected: false,
                level: nil,
                isPlaceholder: false,
                isFiller: true
            )
        }

        return leadingPlaceholders + realDays + trailingPlaceholders + fillers
    }
}
