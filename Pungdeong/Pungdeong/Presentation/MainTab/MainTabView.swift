//
//  MainTabView.swift
//  Pungdeong
//
//  Created by sun on 3/30/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
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
            .tabItem {
                Image(systemName: "calendar")
                Text("캘린더")
            }

            NavigationStack {
                RecordView(
                    viewModel: RecordViewModel(
                        getDayRecordsUseCase: DefaultGetDayRecordsUseCase()
                    )
                )
            }
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("기록")
            }
        }
    }
}
