//
//  RecordViewModel.swift
//  Pungdeong
//
//  Created by sun on 3/29/26.
//

import Combine
import Foundation
import SwiftUI
import SwiftData

@MainActor
final class RecordViewModel: ObservableObject {
    @Published var records: [DailyRecord] = []
    @Published var selectedIndex: Int = 0

    private let selectedDate: Date
    private let getDayRecordsUseCase: GetDayRecordsUseCase
    private let modelContext: ModelContext
    private let calendar = Calendar.current

    init(
        selectedDate: Date,
        getDayRecordsUseCase: GetDayRecordsUseCase,
        modelContext: ModelContext
    ) {
        self.selectedDate = selectedDate
        self.getDayRecordsUseCase = getDayRecordsUseCase
        self.modelContext = modelContext
        load()
    }
    
    var canSave: Bool {
        guard records.indices.contains(selectedIndex) else { return false }
        return records[selectedIndex].level != nil
    }

    var currentRecord: DailyRecord? {
        guard records.indices.contains(selectedIndex) else { return nil }
        return records[selectedIndex]
    }

    func load() {
        let normalizedDate = calendar.startOfDay(for: selectedDate)
        let key = normalizedDate.dayKey

        do {
            let predicate = #Predicate<DailyRecordEntity> { $0.dayKey == key }
            var descriptor = FetchDescriptor<DailyRecordEntity>(predicate: predicate)
            descriptor.fetchLimit = 1

            if let entity = try modelContext.fetch(descriptor).first {
                let level = entity.levelRawValue.flatMap { PungdeongLevel(rawValue: $0) }
                let images = entity.imageDatas.compactMap { $0.toImage() }

                records = [
                    DailyRecord(
                        date: normalizedDate,
                        level: level,
                        memo: entity.memo,
                        images: images
                    )
                ]
            } else {
                records = getDayRecordsUseCase.execute(baseDate: selectedDate)
            }
        } catch {
            print("Record 불러오기 실패:", error)
            records = getDayRecordsUseCase.execute(baseDate: selectedDate)
        }
    }

    func save() {
        guard let record = currentRecord else { return }

        let normalizedDate = calendar.startOfDay(for: record.date)
        let key = normalizedDate.dayKey
        let imageDatas = record.images.compactMap { $0.toData() }

        do {
            let predicate = #Predicate<DailyRecordEntity> { $0.dayKey == key }
            var descriptor = FetchDescriptor<DailyRecordEntity>(predicate: predicate)
            descriptor.fetchLimit = 1

            if let entity = try modelContext.fetch(descriptor).first {
                entity.date = normalizedDate
                entity.levelRawValue = record.level?.rawValue
                entity.memo = record.memo
                entity.imageDatas = imageDatas
            } else {
                let entity = DailyRecordEntity(
                    dayKey: key,
                    date: normalizedDate,
                    levelRawValue: record.level?.rawValue,
                    memo: record.memo,
                    imageDatas: imageDatas
                )
                modelContext.insert(entity)
            }

            try modelContext.save()
            print("Record 저장 성공:", key, "images:", imageDatas.count)
        } catch {
            print("Record 저장 실패:", error)
        }
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
        let today = calendar.startOfDay(for: Date())
        let targetDay = calendar.startOfDay(for: recordDate)

        guard let dayDiff = calendar.dateComponents([.day], from: targetDay, to: today).day else {
            return ""
        }

        return dayDiff == 0 ? "오늘" : "\(dayDiff)일 전"
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter.string(from: date)
    }
}
