//
//  RecordMemoSection.swift
//  Pungdeong
//
//  Created by sun on 3/29/26.
//

import SwiftUI

struct RecordMemoSection: View {
    let memo: String
    let onMemoChange: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("한 줄 기록")
                .font(.headline)

            TextField(
                "오늘 가장 풍덩했던 순간을 짧게 남겨보세요",
                text: Binding(
                    get: { memo },
                    set: { onMemoChange($0) }
                ),
                axis: .vertical
            )
            .lineLimit(3, reservesSpace: true)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.systemGray6))
            )
        }
    }
}
