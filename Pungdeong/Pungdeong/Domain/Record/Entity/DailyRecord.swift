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
    var latitude: Double?
    var longitude: Double?
    var placeName: String?

    init(
        id: UUID = UUID(),
        date: Date,
        level: PungdeongLevel? = nil,
        memo: String = "",
        images: [UIImage] = [],
        latitude: Double? = nil,
        longitude: Double? = nil,
        placeName: String? = nil
    ) {
        self.id = id
        self.date = date
        self.level = level
        self.memo = memo
        self.images = images
        self.latitude = latitude
        self.longitude = longitude
        self.placeName = placeName
    }
}
