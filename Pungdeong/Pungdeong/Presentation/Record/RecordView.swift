//
//  RecordView.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: RecordViewModel

    let customBackAction: (() -> Void)?

    init(
        viewModel: RecordViewModel,
        customBackAction: (() -> Void)? = nil
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.customBackAction = customBackAction
    }

    var body: some View {
        VStack(spacing: 16) {
            PungdeongHeaderView(
                title: "그날의 풍덩",
                subtitle: "얼마나 알차게 시간을 보냈는지 선택해 주세요"
            )
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button {
                    if let customBackAction {
                        customBackAction()
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
            }
            .padding(.horizontal, 20)

            TabView(selection: $viewModel.selectedIndex) {
                ForEach(Array(viewModel.records.enumerated()), id: \.element.id) { index, record in
                    RecordCardView(
                        title: viewModel.title(for: index),
                        dateText: viewModel.formattedDate(record.date),
                        record: viewModel.bindingForRecord(at: index),
                        onSelectLevel: { level in
                            viewModel.updateLevel(level, at: index)
                        },
                        onMemoChange: { memo in
                            viewModel.updateMemo(memo, at: index)
                        }
                    )
                    .tag(index)
                    .padding(.horizontal, 20)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            Button {
                let index = viewModel.selectedIndex
                print("저장 tapped: \(index)")
            } label: {
                Text("저장하기")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 6)
        }
        .padding(.top, 16)
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}
