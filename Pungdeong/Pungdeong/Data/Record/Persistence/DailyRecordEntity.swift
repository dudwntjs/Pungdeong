//
//  DailyRecordEntity.swift
//  Pungdeong
//
//  Created by sun on 4/18/26.
//

import Foundation
import SwiftData

@Model
final class DailyRecordEntity {
    @Attribute(.unique) var dayKey: String
    var date: Date
    var levelRawValue: Int?
    var memo: String
    var imageDatas: [Data]

    init(
        dayKey: String,
        date: Date,
        levelRawValue: Int? = nil,
        memo: String = "",
        imageDatas: [Data] = []
    ) {
        self.dayKey = dayKey
        self.date = date
        self.levelRawValue = levelRawValue
        self.memo = memo
        self.imageDatas = imageDatas
    }
}
