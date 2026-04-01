//
//  RecordView.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

import SwiftUI

struct RecordView: View {
    @StateObject private var viewModel: RecordViewModel

    init(viewModel: RecordViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 20) {
            headerView

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
                    .padding(.horizontal,20)
                    .padding(.vertical, 10)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            pageIndicator
        }
        .padding(.top, 16)
    }

    private var headerView: some View {
        VStack(spacing: 6) {
            Text("그날의 풍덩")
                .font(.title2.bold())

            Text("사진과 함께 얼마나 풍덩했는지 기록해보세요")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<viewModel.records.count, id: \.self) { index in
                Capsule()
                    .fill(index == viewModel.selectedIndex ? Color.black : Color.gray.opacity(0.25))
                    .frame(
                        width: index == viewModel.selectedIndex ? 20 : 8,
                        height: 8
                    )
            }
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    RecordView(
        viewModel: RecordViewModel(
            getDayRecordsUseCase: DefaultGetDayRecordsUseCase()
        )
    )
}
