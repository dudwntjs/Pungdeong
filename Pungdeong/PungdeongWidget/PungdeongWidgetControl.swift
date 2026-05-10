//
//  PungdeongWidgetControl.swift
//  PungdeongWidget
//
//  Created by sun on 4/28/26.
//

import AppIntents
import SwiftUI
import WidgetKit

struct PungdeongWidgetControl: ControlWidget {
    static let kind: String = "sun.Pungdeong.PungdeongLevelControl"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: CyclePungdeongLevelIntent()) {
                Label {
                    Text("풍덩 레벨")
                } icon: {
                    Image("custom.water.waves.circle")
                        .symbolEffect(.breathe.pulse.byLayer, options: .nonRepeating)
                }
            }
        }
        .displayName("풍덩 레벨")
        .description("누를 때마다 얕은 → 중간 → 깊은 순서로 변경됩니다.")
    }
}
