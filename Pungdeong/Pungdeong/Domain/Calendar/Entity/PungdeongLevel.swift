//
//  PungdeongLevel.swift
//  Pungdeong
//
//  Created by sun on 3/28/26.
//

enum PungdeongLevel: Int, CaseIterable, Codable {
    case light = 1
    case medium = 2
    case deep = 3

    var title: String {
        switch self {
        case .light: return "얕은 풍덩"
        case .medium: return "중간 풍덩"
        case .deep: return "깊은 풍덩"
        }
    }

    var description: String {
        switch self {
        case .light: return "조금은 나를 위한 시간을 보냈어요"
        case .medium: return "꽤 몰입해서 알차게 보냈어요"
        case .deep: return "정말 푹 빠져서 풍덩했어요"
        }
    }

    var progress: Double {
        switch self {
        case .light: return 0.33
        case .medium: return 0.66
        case .deep: return 1.0
        }
    }
}
