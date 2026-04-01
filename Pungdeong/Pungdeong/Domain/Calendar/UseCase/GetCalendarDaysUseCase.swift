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

        guard let firstDate = dates.first else { return [] }

        let firstWeekday = repository.firstWeekday(for: firstDate)
        let placeholderCount = max(0, firstWeekday - 1)

        let placeholders = Array(
            repeating: CalendarDay(
                number: nil,
                date: nil,
                isToday: false,
                isSunday: false,
                isSaturday: false,
                isSelected: false,
                level: nil
            ),
            count: placeholderCount
        )

        let realDays = dates.map { date in
            let weekday = repository.weekday(for: date)

            return CalendarDay(
                number: repository.dayNumber(for: date),
                date: date,
                isToday: repository.isToday(date),
                isSunday: weekday == 1,
                isSaturday: weekday == 7,
                isSelected: selectedDate.map { repository.isSameDay($0, date) } ?? false,
                level: levelProvider(date)
            )
        }

        return placeholders + realDays
    }
}
