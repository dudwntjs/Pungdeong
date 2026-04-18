//
//  DefaultGetDayRecordsUseCase.swift
//  Pungdeong
//
//  Created by sun on 3/29/26.
//

import Foundation

final class DefaultGetDayRecordsUseCase: GetDayRecordsUseCase {
    private let calendar = Calendar.current

    func execute(baseDate: Date) -> [DailyRecord] {
        let selectedDay = calendar.startOfDay(for: baseDate)

        return [
            DailyRecord(date: selectedDay)
        ]
    }
}
