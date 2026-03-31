//
//  WeekdayHeaderView.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import SwiftUI

struct WeekdayHeaderView: View {
    private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]

    var body: some View {
        HStack {
            ForEach(Array(weekdays.enumerated()), id: \.offset) { index, day in
                Text(day)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(color(for: index))
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.bottom, 4)
    }

    private func color(for index: Int) -> Color {
        switch index {
        case 0: return .red
        case 6: return .blue
        default: return .black
        }
    }
}
