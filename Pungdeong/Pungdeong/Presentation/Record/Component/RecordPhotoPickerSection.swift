//
//  RecordPhotoPickerSection.swift
//  Pungdeong
//
//  Created by sun on 3/28/26.
//

import PhotosUI
import SwiftUI

struct RecordPhotoPickerSection:View {
    @Binding var images: [UIImage]
    @State private var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        VStack(alignment: .leading,spacing:12) {
            Text("그날의 풍덩 한 장면")
                .font(.headline)
            
            ScrollView(.horizontal,showsIndicators:false) {
                HStack(spacing:12) {
                    ForEach(Array(images.enumerated()),id: \.offset) {_,image in
                        Image(uiImage:image)
                            .resizable()
                            .scaledToFill()
                            .frame(width:96, height:96)
                            .clipShape(RoundedRectangle(cornerRadius:16))
                    }
                    
                    if images.count<3 {
                        PhotosPicker(
                            selection: $selectedItems,
                            maxSelectionCount:3-images.count,
                            matching: .images
                        ) {
                            RoundedRectangle(cornerRadius:16)
                                .stroke(style:StrokeStyle(lineWidth:1,dash: [4]))
                                .frame(width:96,height:96)
                                .overlay {
                                    Image(systemName:"plus")
                                }
                        }
                    }
                }
            }
            .scrollClipDisabled(true)
        }
        .onChange(of: selectedItems) {_, items in
            Task {
                var newImages: [UIImage] = []
                
                for item in items {
                    if let data=try?await item.loadTransferable(type:Data.self),
                    let image=UIImage(data:data) {
                        newImages.append(image)
                    }
                }
                
                images.append(contentsOf:newImages)
                images=Array(images.prefix(3))
                selectedItems = []
            }
        }
    }
}
