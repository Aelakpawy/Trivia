//
//  QuizCategory.swift
//  Trivia
//
//  Created by ahmed.elakpawy on 30.10.24.
//

import SwiftUI

enum GameMode: String, CaseIterable, Identifiable, Codable {
    case classic = "Classic Mode"
    case weeklyChallenge = "Weekly Challenge"
    case timeAttack = "Time Attack"
    case iqTest = "IQ Test"
    case challenge = "Challenge Mode"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .classic: return "gamecontroller.fill"
        case .weeklyChallenge: return "calendar.badge.clock"
        case .timeAttack: return "timer"
        case .iqTest: return "brain.head.profile"
        case .challenge: return "person.2.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .classic: return Color(hex: "00E5FF")
        case .weeklyChallenge: return Color(hex: "FF9F1C")
        case .timeAttack: return Color(hex: "FF6B6B")
        case .iqTest: return Color(hex: "9B5DE5")
        case .challenge: return Color(hex: "9B5DE5")
        }
    }
    
    var description: String {
        switch self {
        case .classic: return "Test your knowledge at your own pace"
        case .weeklyChallenge: return "New Office trivia every week"
        case .timeAttack: return "Race against the clock"
        case .iqTest: return "Test your Intelligence Quotient"
        case .challenge: return "Challenge friends to a quiz battle"
        }
    }
    
    var requiresPremium: Bool {
        switch self {
        case .classic:
            return false
        case .weeklyChallenge, .timeAttack, .iqTest, .challenge:
            return true
        }
    }
}
