//
//  AppIntent.swift
//  PungdeongWidget
//
//  Created by sun on 4/28/26.
//

import AppIntents
import WidgetKit

struct CyclePungdeongLevelIntent: AppIntent {
    static var title: LocalizedStringResource = "풍덩 레벨 변경"
    
    @AppDependency
    var manager: PungdeongLevelManager

    func perform() async throws -> some IntentResult {
        manager.cycle()

        return .result()
    }
}
