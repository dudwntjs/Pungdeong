//
//  MonthYearPickerView.swift
//  Pungdeong
//
//  Created by sun on 3/28/26.
//

import SwiftUI

struct MonthYearPickerView: View {
    let initialYear: Int
    let initialMonth: Int
    let onConfirm: (Int, Int) -> Void

    @State private var selectedYear: Int
    @State private var selectedMonth: Int

    private let years = Array(2020...2035)
    private let months = Array(1...12)

    init(
        initialYear: Int,
        initialMonth: Int,
        onConfirm: @escaping (Int, Int) -> Void
    ) {
        self.initialYear = initialYear
        self.initialMonth = initialMonth
        self.onConfirm = onConfirm

        _selectedYear = State(initialValue: initialYear)
        _selectedMonth = State(initialValue: initialMonth)
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()

                Button("완료") {
                    onConfirm(selectedYear, selectedMonth)
                }
                .fontWeight(.semibold)
                .foregroundStyle(.black)
            }

            HStack(spacing: 0) {
                Picker("연도", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text(verbatim: "\(year)년")
                            .tag(year)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)

                Picker("월", selection: $selectedMonth) {
                    ForEach(months, id: \.self) { month in
                        Text(verbatim: "\(month)월")
                            .tag(month)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
            }
            .frame(height: 180)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        )
    }
}
