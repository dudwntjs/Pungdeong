//
//  CalendarDateCellView.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import SwiftUI

struct CalendarDateCellView: View {
    let day: CalendarDay

    var body: some View {
        ZStack(alignment: .top) {

            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    day.isSelected ? Color.blue.opacity(0.6) : Color.clear,
                    lineWidth: 2
                )

            VStack(spacing: 4) {

                Text(day.number.map(String.init) ?? "")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(textColor)
                    .padding(.top, 6)

                Spacer()

                if !day.isPlaceholder, let level = day.level {
                    Image(imageName(for: level))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.bottom, 6)
                }
            }
        }
        .frame(height: 72)
    }

    private func imageName(for level: PungdeongLevel) -> String {
        switch level {
        case .light: return "Progress1"
        case .medium: return "Progress2"
        case .deep: return "Progress3"
        }
    }

    private var textColor: Color {
        if day.isPlaceholder { return .gray }
        if day.isSunday { return .red }
        if day.isSaturday { return .blue }
        return .black
    }
}
