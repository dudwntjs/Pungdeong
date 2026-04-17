//
//  BluePin.swift
//  Pungdeong
//
//  Created by sun on 4/17/26.
//

import SwiftUI

struct BluePin: View {
    let imageName: String

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(
                        AngularGradient(
                            colors: [.blue],
                            center: .center
                        )
                    )
                    .frame(width: 52, height: 52)

                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            .shadow(color: .black.opacity(0.2), radius: 4, y: 2)

            Image(systemName: "triangle.fill")
                .font(.caption2)
                .foregroundStyle(.blue)
                .rotationEffect(.degrees(180))
                .offset(y: -3)
        }
    }
}
