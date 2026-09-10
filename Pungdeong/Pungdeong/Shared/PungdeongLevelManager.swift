//
//  PungdeongLevelManager.swift
//  Pungdeong
//
//  Created by sun on 5/9/26.
//

import Foundation

final class PungdeongLevelManager: Sendable {
    
    private let defaults = UserDefaults(
        suiteName: "group.sun.pungdeong"
    )!
    
    private var todayKey: String {
        "pungdeongLevel-\(Date().dayKey)"
    }
    
    var todayLevel: PungdeongLevel? {
        get {
            guard let rawValue = defaults.object(forKey: todayKey) as? Int
            else {
                return nil
            }
            
            return PungdeongLevel(rawValue: rawValue)
        }
        
        set {
            defaults.set(newValue?.rawValue, forKey: todayKey)
        }
    }
    
    func cycle() {
        print("오늘 key:", todayKey)
        print("현재 레벨:", String(describing: todayLevel))
        
        todayLevel = todayLevel.nextLevel
        
        print("변경 후 레벨:", String(describing: todayLevel))
        
    }
}
