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
                            colors: [.blue.opacity(0.9)],
                            center: .center
                        )
                    )
                    .frame(width: 40, height: 40)

                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
            }
            .shadow(color: .black.opacity(0.2), radius: 4, y: 2)

            Image(systemName: "triangle.fill")
                .font(.caption2)
                .foregroundStyle(.blue.opacity(0.9))
                .rotationEffect(.degrees(180))
                .offset(y: -3)
        }
    }
}
