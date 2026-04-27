//
//  PungdeongBottomSheetView.swift
//  Pungdeong
//
//  Created by sun on 3/28/26.
//

import SwiftUI

struct PungdeongBottomSheetView: View {
    let selectedDate: Date?
    let onSelectLevel: (PungdeongLevel) -> Void
    let onTapDetail: (() -> Void)?

    init(
        selectedDate: Date?,
        onSelectLevel: @escaping (PungdeongLevel) -> Void,
        onTapDetail: (() -> Void)? = nil
    ) {
        self.selectedDate = selectedDate
        self.onSelectLevel = onSelectLevel
        self.onTapDetail = onTapDetail
    }

    var body: some View {
        VStack(spacing: 24) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 44, height: 6)
                .padding(.top, 8)

            VStack(spacing: 8) {
                Text("얼마나 풍덩했나요?")
                    .font(.title3.weight(.bold))

                Text("얼마나 알차게 시간을 보냈는지 선택해 주세요.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
            }

            VStack(spacing: 12) {
                levelButton(.light, imageName: "Progress1")
                levelButton(.medium, imageName: "Progress2")
                levelButton(.deep, imageName: "Progress3")
            }

            Button {
                onTapDetail?()
            } label: {
                HStack(spacing: 6) {
                    Text("더 자세히 기록해볼까요?")
                    Image(systemName: "chevron.right")
                }
                .font(.headline)
                .foregroundStyle(.secondary)
            }
            .padding(.top, 8)

            Spacer(minLength: 0)
        }
        .padding()
        .presentationDetents([.height(430)])
        .presentationBackground(.white)
    }

    private func levelButton(_ level: PungdeongLevel, imageName: String) -> some View {
        Button {
            onSelectLevel(level)
        } label: {
            HStack(spacing: 12) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)

                VStack(alignment: .leading, spacing: 4) {
                    Text(level.title)
                        .font(.headline)
                        .foregroundStyle(.blue)

                    Text(level.description)
                        .font(.subheadline)
                        .foregroundStyle(.blue.opacity(0.45))
                }

                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}
