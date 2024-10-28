//
//  QuizCategory.swift
//  Trivia
//
//  Created by ahmed.elakpawy on 30.10.24.
//

import SwiftUI

enum QuizCategory: String, CaseIterable, Identifiable, Codable {
    case general = "general knowledge"
    case science = "science"
    case history = "history"
    case geography = "geography"
    case entertainment = "entertainment"
    case sports = "sports"
    case technology = "technology"
    case art = "art & literature"

    var id: String { self.rawValue }

    var icon: String {
        switch self {
        case .general: return "brain.head.profile"
        case .science: return "atom"
        case .history: return "clock.fill"
        case .geography: return "globe.americas.fill"
        case .entertainment: return "film.fill"
        case .sports: return "sportscourt.fill"
        case .technology: return "laptopcomputer"
        case .art: return "paintpalette.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .general: return Color(hex: "00E5FF")
        case .science: return Color(hex: "FF6B6B")
        case .history: return Color(hex: "4ECDC4")
        case .geography: return Color(hex: "45B7D1")
        case .entertainment: return Color(hex: "96CEB4")
        case .sports: return Color(hex: "FF9F1C")
        case .technology: return Color(hex: "9B5DE5")
        case .art: return Color(hex: "F15BB5")
        }
    }
    
    var description: String {
        switch self {
        case .general: return "Test your knowledge across various topics"
        case .science: return "Explore the wonders of science and nature"
        case .history: return "Journey through time and historical events"
        case .geography: return "Travel the world through exciting questions"
        case .entertainment: return "Movies, TV shows, music, and pop culture"
        case .sports: return "Challenge yourself with sports trivia"
        case .technology: return "Dive into the world of tech and innovation"
        case .art: return "Discover art, literature, and culture"
        }
    }
}
