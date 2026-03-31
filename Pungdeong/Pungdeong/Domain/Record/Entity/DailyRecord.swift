//
//  DailyRecord.swift
//  Pungdeong
//
//  Created by sun on 3/29/26.
//

import SwiftUI

struct DailyRecord: Identifiable, Equatable {
    let id: UUID
    let date: Date
    var level: PungdeongLevel?
    var memo: String
    var images: [UIImage]

    init(
        id: UUID = UUID(),
        date: Date,
        level: PungdeongLevel? = nil,
        memo: String = "",
        images: [UIImage] = []
    ) {
        self.id = id
        self.date = date
        self.level = level
        self.memo = memo
        self.images = images
    }
}
