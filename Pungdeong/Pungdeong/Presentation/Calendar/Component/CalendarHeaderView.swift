//
//  CalendarHeaderView.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import SwiftUI

struct CalendarHeaderView: View {
    let title: String
    let onTapMonthPicker: () -> Void
    let onTapPrevious: () -> Void
    let onTapNext: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onTapMonthPicker) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.system(size: 24, weight: .bold))

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundStyle(.black)
            }

            Spacer()

            Button(action: onTapPrevious) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.black)
            }

            Button(action: onTapNext) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.black)
            }
        }
        .padding(.bottom, 10)
    }
}
