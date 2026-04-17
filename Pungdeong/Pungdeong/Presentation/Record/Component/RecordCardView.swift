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
    let onSave: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.title3.bold())
                        
                        Text(dateText)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    RecordLevelSection(
                        selectedLevel: record.level,
                        onSelectLevel: onSelectLevel
                    )
                    
                    Text("그날의 풍덩 장소")
                        .font(.headline)
                    
                    RecordMapView()
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    RecordPhotoPickerSection(images: $record.images)
                    
                    RecordMemoSection(
                        memo: record.memo,
                        onMemoChange: onMemoChange
                    )
                }
                .padding(20)
            }
            
            Button(action: onSave) {
                Text("저장하기")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.white)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        )
    }
}
