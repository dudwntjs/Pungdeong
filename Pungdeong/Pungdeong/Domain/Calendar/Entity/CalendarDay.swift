//
//  CalendarDay.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import Foundation

struct CalendarDay: Identifiable, Equatable {
    let id = UUID()
    let number: Int?
    let date: Date?
    let isToday: Bool
    let isSunday: Bool
    let isSaturday: Bool
    let isSelected: Bool
    let level: PungdeongLevel?

    var isPlaceholder: Bool {
        number == nil || date == nil
    }

    var progress: Double {
        level?.progress ?? 0
    }
}
