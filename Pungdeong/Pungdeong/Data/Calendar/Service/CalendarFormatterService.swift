//
//  CalendarFormatterService.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import Foundation

protocol CalendarFormatterService {
    func headerString(from date: Date) -> String
}

final class DefaultCalendarFormatterService: CalendarFormatterService {
    private let formatter: DateFormatter

    init() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        self.formatter = formatter
    }

    func headerString(from date: Date) -> String {
        formatter.string(from: date)
    }
}
