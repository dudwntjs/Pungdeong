//
//  RecordCardView.swift
//  Pungdeong
//
//  Created by sun on 3/29/26.
//

import SwiftUI
import MapKit

struct RecordCardView: View {
    let title: String
    let dateText: String
    @Binding var record: DailyRecord
    
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var selectedPlaceName: String
    
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
                
                RecordLevelSection(
                    selectedLevel: record.level,
                    onSelectLevel: onSelectLevel
                )
                
                Text("그날의 풍덩 장소")
                    .font(.headline)
                
                RecordMapView(
                    result: $selectedCoordinate,
                   currentKeyword: $selectedPlaceName
                )
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
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        )
    }
}
