//
//  CalendarView.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel: CalendarViewModel
    @State private var goToRecord = false

    init(viewModel: CalendarViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {

                PungdeongHeaderView(
                    title: "이달의 풍덩",
                    subtitle: "그날 얼마나 풍덩했는지 남겨보세요"
                )

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
                .frame(maxWidth: .infinity)
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
                    onSelectLevel: viewModel.savePungdeong,
                    onTapDetail: {
                        viewModel.isPungdeongSheetPresented = false
                        goToRecord = true
                    }
                )
                .presentationBackground(.white)
            }
            .alert("기록하시겠어요?", isPresented: $viewModel.showFutureDateAlert) {
                Button("취소", role: .cancel) { }

                Button("기록하기") {
                    viewModel.confirmFutureDateRecording()
                }
            } message: {
                Text("아직 미래의 날짜인데 기록하시겠어요?")
            }
            .navigationDestination(isPresented: $goToRecord) {
                if let selectedDate = viewModel.selectedDate {
                    RecordView(
                        viewModel: RecordViewModel(
                            selectedDate: selectedDate,
                            getDayRecordsUseCase: DefaultGetDayRecordsUseCase()
                        ),
                        onSave: { record in
                            viewModel.saveRecord(record)
                            goToRecord = false
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}
