//
//  PungdeongHeaderView.swift
//  Pungdeong
//
//  Created by sun on 3/31/26.
//

import SwiftUI

struct PungdeongHeaderView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.title2.bold())

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}
