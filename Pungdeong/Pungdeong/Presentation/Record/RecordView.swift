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
        VStack(spacing: 16) {
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
    }
}

#Preview {
    RecordView(
        viewModel: RecordViewModel(
            getDayRecordsUseCase: DefaultGetDayRecordsUseCase()
        )
    )
}
