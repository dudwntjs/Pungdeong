//
//  CalendarView.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
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
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let horizontalAmount = value.translation.width
                        let verticalAmount = value.translation.height

                        guard abs(horizontalAmount) > abs(verticalAmount) else { return }
                        guard abs(horizontalAmount) > 30 else { return }
                        
                        if horizontalAmount < 0 {
                            viewModel.tapNextMonth()
                        } else {
                            viewModel.tapPreviousMonth()
                        }
                    }
            )
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
                    selectedLevel: viewModel.selectedLevel,
                    onSelectLevel: { level in
                        guard let selectedDate = viewModel.selectedDate else { return }

                        let record = DailyRecord(
                            date: selectedDate,
                            level: level,
                            memo: ""
                        )

                        viewModel.saveRecord(record, context: modelContext)
                        viewModel.isPungdeongSheetPresented = false
                    },
                    onTapDetail: {
                        viewModel.isPungdeongSheetPresented = false
                        goToRecord = true
                    }
                )
                .presentationBackground(.white)
            }
            .alert("기록을 남길 수 없어요", isPresented: $viewModel.showFutureDateAlert) {
                Button("돌아가기", role: .cancel) { }

            } message: {
                Text("풍덩했던 기록을 적어야해요")
            }
            .navigationDestination(isPresented: $goToRecord) {
                if let selectedDate = viewModel.selectedDate {
                    RecordView(
                        viewModel: RecordViewModel(
                            selectedDate: selectedDate,
                            getDayRecordsUseCase: DefaultGetDayRecordsUseCase(),
                            modelContext: modelContext
                        ),
                        customBackAction: {
                            viewModel.loadSavedRecords(context: modelContext)
                            goToRecord = false
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .onAppear {
            viewModel.loadSavedRecords(context: modelContext)
        }
    }
}
