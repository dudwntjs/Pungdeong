//
//  FormatCalendarHeaderUseCase.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import Foundation

protocol FormatCalendarHeaderUseCase {
    func execute(baseDate: Date, offset: Int) -> String
}

final class DefaultFormatCalendarHeaderUseCase: FormatCalendarHeaderUseCase {
    private let repository: CalendarRepository

    init(repository: CalendarRepository) {
        self.repository = repository
    }

    func execute(baseDate: Date, offset: Int) -> String {
        let monthDate = repository.makeMonthDate(from: baseDate, offset: offset)
        return repository.formatHeader(from: monthDate)
    }
}
