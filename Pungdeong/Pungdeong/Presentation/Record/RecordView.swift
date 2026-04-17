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
            PungdeongHeaderView(
                title: "그날의 풍덩",
                subtitle: "사진과 함께 얼마나 풍덩했는지 기록해보세요"
            )

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
                        },
                        onSave: {
                            print("저장 tapped: \(index)")
                        }
                    )
                    .tag(index)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .padding(.top, 16)
    }
}

#Preview {
    RecordView(
        viewModel: RecordViewModel(
            getDayRecordsUseCase: DefaultGetDayRecordsUseCase()
        )
    )
}
