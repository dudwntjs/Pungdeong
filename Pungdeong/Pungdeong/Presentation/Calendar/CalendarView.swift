//
//  CalendarView.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel: CalendarViewModel

    init(viewModel: CalendarViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 20) {
            
            headerView
            
            VStack(spacing: 30) {
                CalendarHeaderView(
                    title: viewModel.headerTitle,
                    onTapMonthPicker: viewModel.toggleMonthPicker,
                    onTapPrevious: viewModel.tapPreviousMonth,
                    onTapNext: viewModel.tapNextMonth
                )

                WeekdayHeaderView()
            }

            CalendarGridView(
                days: viewModel.days,
                onTapDate: viewModel.select
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .overlay(alignment: .top) {
            if viewModel.isMonthPickerExpanded {
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.closeMonthPicker()
                        }

                    MonthYearPickerView(
                        initialYear: viewModel.displayedYear,
                        initialMonth: viewModel.displayedMonth,
                        onConfirm: viewModel.changeMonth(year:month:)
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 56)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.isMonthPickerExpanded)
        .sheet(isPresented: $viewModel.isPungdeongSheetPresented) {
            PungdeongBottomSheetView(
                selectedDate: viewModel.selectedDate,
                onSelectLevel: viewModel.savePungdeong
            )
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 6) {
            Text("이달의 풍덩")
                .font(.title2.bold())
            
            Text("그날 얼마나 풍덩했는지 남겨보세요")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    let repository = DefaultCalendarRepository()

    let viewModel = CalendarViewModel(
        getCalendarDaysUseCase: DefaultGetCalendarDaysUseCase(
            repository: repository
        ),
        moveMonthUseCase: DefaultMoveMonthUseCase(),
        formatCalendarHeaderUseCase: DefaultFormatCalendarHeaderUseCase(
            repository: repository
        )
    )

    return CalendarView(viewModel: viewModel)
}
