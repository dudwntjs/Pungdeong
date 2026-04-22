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
    let onSave: ((DailyRecord) -> Void)?
    
    init(
        viewModel: RecordViewModel,
        customBackAction: (() -> Void)? = nil,
        onSave: ((DailyRecord) -> Void)? = nil
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.customBackAction = customBackAction
        self.onSave = onSave
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
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
                    viewModel.save()
                    
                    if let customBackAction {
                        customBackAction()
                    } else {
                        dismiss()
                    }
                } label: {
                    Text("저장하기")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(viewModel.canSave ? Color.blue : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .disabled(!viewModel.canSave)
                .padding(.horizontal, 20)
                .padding(.bottom, 6)
            }
            .padding(.top, 16)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}
