//
//  CalendarViewModel.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import Combine
import Foundation
import SwiftUI
import SwiftData

@MainActor
final class CalendarViewModel: ObservableObject {
    @Published var currentMonthOffset: Int = 0
    @Published var selectedDate: Date?
    @Published var headerTitle: String = ""

    @Published var days: [CalendarDay] = []
    @Published var previousMonthDays: [CalendarDay] = []
    @Published var nextMonthDays: [CalendarDay] = []

    @Published var isPungdeongSheetPresented: Bool = false
    @Published var isMonthPickerExpanded: Bool = false
    @Published var showFutureDateAlert: Bool = false

    @Published var records: [String: PungdeongLevel] = [:]

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
        self.selectedDate = calendar.startOfDay(for: baseDate)

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

    var selectedLevel: PungdeongLevel? {
        guard let selectedDate else { return nil }
        return records[selectedDate.dayKey]
    }

    func reload() {
        headerTitle = formatCalendarHeaderUseCase.execute(
            baseDate: baseDate,
            offset: currentMonthOffset
        )

        previousMonthDays = makeDays(offset: currentMonthOffset - 1)
        days = makeDays(offset: currentMonthOffset)
        nextMonthDays = makeDays(offset: currentMonthOffset + 1)
    }

    func loadSavedRecords(context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<DailyRecordEntity>()
            let entities = try context.fetch(descriptor)

            let mapped: [String: PungdeongLevel] = Dictionary(
                uniqueKeysWithValues: entities.compactMap { entity in
                    guard let raw = entity.levelRawValue,
                          let level = PungdeongLevel(rawValue: raw) else {
                        return nil
                    }
                    return (entity.dayKey, level)
                }
            )

            records = mapped
            reload()
        } catch {
            print("불러오기 실패: \(error)")
        }
    }

    func saveRecord(_ record: DailyRecord, context: ModelContext) {
        let normalizedDate = normalize(record.date)
        let key = normalizedDate.dayKey

        print("=== saveRecord start ===")
        print("normalizedDate:", normalizedDate)
        print("key:", key)
        print("level:", record.level as Any)
        print("rawValue:", record.level?.rawValue as Any)

        do {
            let predicate = #Predicate<DailyRecordEntity> { $0.dayKey == key }
            var descriptor = FetchDescriptor<DailyRecordEntity>(predicate: predicate)
            descriptor.fetchLimit = 1

            let existing = try context.fetch(descriptor).first
            let imageDatas = record.images.compactMap { $0.toData() }

            if let existing {
                existing.date = normalizedDate
                existing.levelRawValue = record.level?.rawValue
                existing.memo = record.memo
                existing.imageDatas = imageDatas
            } else {
                let entity = DailyRecordEntity(
                    dayKey: key,
                    date: normalizedDate,
                    levelRawValue: record.level?.rawValue,
                    memo: record.memo,
                    imageDatas: imageDatas
                )
                context.insert(entity)
            }

            try context.save()
            loadSavedRecords(context: context)

        } catch {
            print("저장 실패: \(error)")
        }
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
        let normalizedDate = normalize(date)

        selectedDate = normalizedDate

        if isFutureDate(normalizedDate) {
            showFutureDateAlert = true
            reload()
            return
        }

        isPungdeongSheetPresented = true
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

    func confirmFutureDateRecording() {
        isPungdeongSheetPresented = true
    }

    private func makeDays(offset: Int) -> [CalendarDay] {
        getCalendarDaysUseCase.execute(
            baseDate: baseDate,
            offset: offset,
            selectedDate: selectedDate,
            levelProvider: { [weak self] date in
                self?.level(for: date)
            }
        )
    }

    private func level(for date: Date) -> PungdeongLevel? {
        records[date.dayKey]
    }

    private func normalize(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    private func isFutureDate(_ date: Date) -> Bool {
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: date)
        return target > today
    }
}
