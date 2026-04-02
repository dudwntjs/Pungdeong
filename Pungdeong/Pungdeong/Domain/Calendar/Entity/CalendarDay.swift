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
    let isPlaceholder: Bool
    let isFiller: Bool

    var progress: Double {
        level?.progress ?? 0
    }
}
