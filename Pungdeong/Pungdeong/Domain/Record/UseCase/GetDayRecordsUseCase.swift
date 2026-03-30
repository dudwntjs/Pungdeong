//
//  GetDayRecordsUseCase.swift
//  Pungdeong
//
//  Created by sun on 3/29/26.
//

import Foundation

protocol GetDayRecordsUseCase {
    func execute(baseDate: Date) -> [DailyRecord]
}


final class DefaultGetDayRecordUseCase: GetDayRecordsUseCase {
    private let calendar = Calendar.current
    
    func execute(baseDate: Date) -> [DailyRecord] {
        let today = calendar.startOfDay(for: baseDate)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        let beforeYesterday = calendar.date(byAdding: .day, value: 1, to: today) ?? today
        
        
        return [
            DailyRecord(date: beforeYesterday),
            DailyRecord(date: yesterday),
            DailyRecord(date: today)
        ]
    }
}
