//
//  CalendarGridView.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import SwiftUI

struct CalendarGridView: View {
    let days: [CalendarDay]
    let onTapDate: (CalendarDay) -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 7)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 18) {
            ForEach(days) { day in
                CalendarDateCellView(day: day)
                    .onTapGesture {
                        if !day.isPlaceholder {
                            onTapDate(day)
                        }
                    }
            }
        }
    }
}
