//
//  PungdeongWidgetBundle.swift
//  PungdeongWidget
//
//  Created by sun on 4/28/26.
//

import SwiftUI
import WidgetKit
import AppIntents

@main
struct PungdeongWidgetBundle: WidgetBundle {
    // NOTE: 재성의 과제
    // @AppDependency 사용법 익히기
    init() {
        AppDependencyManager.shared.add(
            dependency: PungdeongLevelManager()
        )
    }
        
    var body: some Widget {
        PungdeongWidgetControl()
    }
}
