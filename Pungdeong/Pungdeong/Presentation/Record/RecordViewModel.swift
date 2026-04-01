//
//  RecordViewModel.swift
//  Pungdeong
//
//  Created by sun on 3/29/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class RecordViewModel: ObservableObject {
    @Published var records: [DailyRecord] = []
    @Published var selectedIndex: Int = 1

    private let getDayRecordsUseCase: GetDayRecordsUseCase

    init(getDayRecordsUseCase: GetDayRecordsUseCase) {
        self.getDayRecordsUseCase = getDayRecordsUseCase
        load()
    }

    func load() {
        records = getDayRecordsUseCase.execute(baseDate: Date())
    }

    func updateLevel(_ level: PungdeongLevel, at index: Int) {
        guard records.indices.contains(index) else { return }
        records[index].level = level
    }

    func updateMemo(_ memo: String, at index: Int) {
        guard records.indices.contains(index) else { return }
        records[index].memo = memo
    }

    func addImages(_ images: [UIImage], at index: Int) {
        guard records.indices.contains(index) else { return }
        let current = records[index].images
        records[index].images = Array((current + images).prefix(3))
    }

    func removeImage(at imageIndex: Int, recordIndex: Int) {
        guard records.indices.contains(recordIndex) else { return }
        guard records[recordIndex].images.indices.contains(imageIndex) else { return }
        records[recordIndex].images.remove(at: imageIndex)
    }

    func bindingForRecord(at index: Int) -> Binding<DailyRecord> {
        Binding(
            get: { self.records[index] },
            set: { self.records[index] = $0 }
        )
    }

    func title(for index: Int) -> String {
        guard records.indices.contains(index) else { return "" }
        let recordDate = records[index].date
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if calendar.isDate(recordDate, inSameDayAs: today) {
            return "오늘"
        } else if calendar.isDate(
            recordDate,
            inSameDayAs: calendar.date(byAdding: .day, value: -1, to: today) ?? today
        ) {
            return "어제"
        } else if calendar.isDate(
            recordDate,
            inSameDayAs: calendar.date(byAdding: .day, value: -2, to: today) ?? today
        ) {
            return "그저께"
        } else {
            return formattedDate(recordDate)
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter.string(from: date)
    }
}
