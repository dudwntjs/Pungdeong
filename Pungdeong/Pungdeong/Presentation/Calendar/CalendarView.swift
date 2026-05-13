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
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel: CalendarViewModel
    @State private var goToRecord = false
    @State private var dragOffset: CGFloat = 0
    @State private var pageWidth: CGFloat = 0

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
                        onTapPrevious: moveToPreviousMonthByButton,
                        onTapNext: moveToNextMonthByButton
                    )

                    WeekdayHeaderView()
                }

                monthCarousel
                    .frame(maxWidth: .infinity)
                    .frame(height: 320)
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
            let manager = PungdeongLevelManager()

            if let level = manager.todayLevel {
                let record = DailyRecord(
                    date: Date(),
                    level: level,
                    memo: ""
                )

                viewModel.saveRecord(record, context: modelContext)
            }

            viewModel.loadSavedRecords(context: modelContext)
        }
    }

    private var monthCarousel: some View {
        GeometryReader { geometry in
            let width = geometry.size.width

            HStack(spacing: 8) {
                CalendarGridView(
                    days: viewModel.previousMonthDays,
                    onTapDate: viewModel.select
                )
                .frame(width: width - 4)

                CalendarGridView(
                    days: viewModel.days,
                    onTapDate: viewModel.select
                )
                .frame(width: width - 4)

                CalendarGridView(
                    days: viewModel.nextMonthDays,
                    onTapDate: viewModel.select
                )
                .frame(width: width - 4)
            }
            .offset(x: -width + dragOffset)
            .contentShape(Rectangle())
            .onAppear {
                pageWidth = width
            }
            .onChange(of: scenePhase) { _, newPhase in
                guard newPhase == .active else { return }

                let manager = PungdeongLevelManager()

                if let level = manager.todayLevel {
                    let record = DailyRecord(
                        date: Date(),
                        level: level,
                        memo: ""
                    )

                    viewModel.saveRecord(record, context: modelContext)
                }

                viewModel.loadSavedRecords(context: modelContext)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let horizontal = value.translation.width
                        let vertical = value.translation.height

                        guard abs(horizontal) > abs(vertical) else { return }
                        dragOffset = horizontal
                    }
                    .onEnded { value in
                        let horizontal = value.translation.width
                        let vertical = value.translation.height
                        let threshold = width * 0.2

                        guard abs(horizontal) > abs(vertical) else {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                dragOffset = 0
                            }
                            return
                        }

                        if horizontal < -threshold {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                dragOffset = -width
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                viewModel.tapNextMonth()
                                dragOffset = 0
                            }
                        } else if horizontal > threshold {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                dragOffset = width
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                viewModel.tapPreviousMonth()
                                dragOffset = 0
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                dragOffset = 0
                            }
                        }
                    }
            )
            .clipped()
        }
    }

    private func moveToNextMonthByButton() {
        guard pageWidth > 0 else {
            viewModel.tapNextMonth()
            return
        }

        withAnimation(.easeInOut(duration: 0.25)) {
            dragOffset = -pageWidth
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            viewModel.tapNextMonth()
            dragOffset = 0
        }
    }

    private func moveToPreviousMonthByButton() {
        guard pageWidth > 0 else {
            viewModel.tapPreviousMonth()
            return
        }

        withAnimation(.easeInOut(duration: 0.25)) {
            dragOffset = pageWidth
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            viewModel.tapPreviousMonth()
            dragOffset = 0
        }
    }
}

#Preview {
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
    .modelContainer(for: [DailyRecordEntity.self])
}
