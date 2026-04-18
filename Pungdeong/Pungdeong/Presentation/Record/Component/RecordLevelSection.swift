//
//  RecordLevelSection.swift
//  Pungdeong
//
//  Created by sun on 3/29/26.
//

import SwiftUI

struct RecordLevelSection: View {
    let selectedLevel: PungdeongLevel?
    let onSelectLevel: (PungdeongLevel) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("그날 얼마나 풍덩했나요?")
                .font(.headline)

            HStack(spacing: 12) {
                levelButton(.light, imageName: "Progress1")
                levelButton(.medium, imageName: "Progress2")
                levelButton(.deep, imageName: "Progress3")
            }
        }
    }

    private func levelButton(_ level: PungdeongLevel, imageName: String) -> some View {
        Button {
            onSelectLevel(level)
        } label: {
            VStack(spacing: 10) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 46, height: 46)

                Text(level.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(selectedLevel == level ? Color.blue.opacity(0.12) : Color(.systemGray6))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        selectedLevel == level ? Color.blue.opacity(0.6) : Color.clear,
                        lineWidth: 1.5
                    )
            }
        }
    }
}
