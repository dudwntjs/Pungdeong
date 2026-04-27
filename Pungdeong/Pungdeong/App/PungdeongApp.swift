//
//  PungdeongApp.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import SwiftUI
import SwiftData

@main
struct PungdeongApp: App {
    var body: some Scene {
        WindowGroup {
            CalendarView(
                viewModel: CalendarViewModel(
                    getCalendarDaysUseCase: DefaultGetCalendarDaysUseCase(
                        repository: DefaultCalendarRepository()
                    ),
                    moveMonthUseCase: DefaultMoveMonthUseCase(),
                    formatCalendarHeaderUseCase: DefaultFormatCalendarHeaderUseCase(
                        repository: DefaultCalendarRepository()
                    )
                )
            )
        }
        .modelContainer(for: [DailyRecordEntity.self])
    }
}
