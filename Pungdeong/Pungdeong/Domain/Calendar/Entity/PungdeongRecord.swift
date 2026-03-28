//
//  PungdeongRecord.swift
//  Pungdeong
//
//  Created by sun on 3/28/26.
//

import Foundation

struct PungdeongRecord: Identifiable, Equatable, Codable {
    let id: UUID
    let date: Date
    let level: PungdeongLevel

    init(id: UUID = UUID(), date: Date, level: PungdeongLevel) {
        self.id = id
        self.date = date
        self.level = level
    }
}
