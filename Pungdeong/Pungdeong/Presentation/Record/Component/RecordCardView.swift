//
//  RecordCardView.swift
//  Pungdeong
//
//  Created by sun on 3/29/26.
//

import SwiftUI

struct RecordCardView: View {
    let title: String
    let dateText: String
    @Binding var record: DailyRecord
    let onSelectLevel: (PungdeongLevel) -> Void
    let onMemoChange: (String) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title3.bold())

                    Text(dateText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                RecordPhotoPickerSection(images: $record.images)

                RecordLevelSection(
                    selectedLevel: record.level,
                    onSelectLevel: onSelectLevel
                )

                RecordMemoSection(
                    memo: record.memo,
                    onMemoChange: onMemoChange
                )
            }
            .padding(20)
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        )
    }
}
