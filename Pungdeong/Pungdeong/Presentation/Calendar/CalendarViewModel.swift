//
//  CalendarViewModel.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class CalendarViewModel: ObservableObject {
    @Published var currentMonthOffset: Int = 0
    @Published var selectedDate: Date?
    @Published var headerTitle: String = ""
    @Published var days: [CalendarDay] = []
    @Published var isPungdeongSheetPresented: Bool = false
    @Published var isMonthPickerExpanded: Bool = false

    @Published private(set) var records: [Date: PungdeongLevel] = [:]

    private let baseDate: Date
    private let getCalendarDaysUseCase: GetCalendarDaysUseCase
    private let moveMonthUseCase: MoveMonthUseCase
    private let formatCalendarHeaderUseCase: FormatCalendarHeaderUseCase
    private let calendar = Calendar.current

    init(
        baseDate: Date = Date(),
        getCalendarDaysUseCase: GetCalendarDaysUseCase,
        moveMonthUseCase: MoveMonthUseCase,
        formatCalendarHeaderUseCase: FormatCalendarHeaderUseCase
    ) {
        self.baseDate = baseDate
        self.getCalendarDaysUseCase = getCalendarDaysUseCase
        self.moveMonthUseCase = moveMonthUseCase
        self.formatCalendarHeaderUseCase = formatCalendarHeaderUseCase

        reload()
    }

    var displayedMonthDate: Date {
        calendar.date(byAdding: .month, value: currentMonthOffset, to: baseDate) ?? baseDate
    }

    var displayedYear: Int {
        calendar.component(.year, from: displayedMonthDate)
    }

    var displayedMonth: Int {
        calendar.component(.month, from: displayedMonthDate)
    }

    func reload() {
        headerTitle = formatCalendarHeaderUseCase.execute(
            baseDate: baseDate,
            offset: currentMonthOffset
        )

        days = getCalendarDaysUseCase.execute(
            baseDate: baseDate,
            offset: currentMonthOffset,
            selectedDate: selectedDate,
            levelProvider: { [weak self] date in
                self?.level(for: date)
            }
        )
    }

    func tapPreviousMonth() {
        isMonthPickerExpanded = false
        currentMonthOffset = moveMonthUseCase.execute(
            currentOffset: currentMonthOffset,
            step: -1
        )
        reload()
    }

    func tapNextMonth() {
        isMonthPickerExpanded = false
        currentMonthOffset = moveMonthUseCase.execute(
            currentOffset: currentMonthOffset,
            step: 1
        )
        reload()
    }

    func select(_ day: CalendarDay) {
        guard let date = day.date else { return }
        selectedDate = date
        isPungdeongSheetPresented = true
        reload()
    }

    func savePungdeong(_ level: PungdeongLevel) {
        guard let selectedDate else { return }

        let normalizedDate = normalize(selectedDate)
        records[normalizedDate] = level

        isPungdeongSheetPresented = false
        reload()
    }

    func closeSheet() {
        isPungdeongSheetPresented = false
    }

    func toggleMonthPicker() {
        isMonthPickerExpanded.toggle()
    }

    func closeMonthPicker() {
        isMonthPickerExpanded = false
    }

    func changeMonth(year: Int, month: Int) {
        guard
            let targetDate = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
            let baseMonthDate = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            return
        }

        let diff = calendar.dateComponents([.month], from: baseMonthDate, to: targetDate).month ?? 0
        currentMonthOffset = diff
        isMonthPickerExpanded = false
        reload()
    }

    private func level(for date: Date) -> PungdeongLevel? {
        let normalizedDate = normalize(date)
        return records[normalizedDate]
    }

    private func normalize(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
}
