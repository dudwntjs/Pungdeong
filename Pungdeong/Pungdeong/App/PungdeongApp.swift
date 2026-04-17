//
//  PungdeongApp.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import SwiftUI

@main
struct PungdeongApp: App {
    var body: some Scene {
        WindowGroup {
<<<<<<< HEAD
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
    }
}
