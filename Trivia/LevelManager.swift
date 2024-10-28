//
//  LevelManager.swift
//  Trivia
//
//  Created by ahmed.elakpawy on 29.10.24.
//

import Foundation

struct Level {
    let name: String
    let minScore: Int
    let maxScore: Int
    let image: String // System image name for each level
}

class LevelManager: ObservableObject {
    static let shared = LevelManager()
    
    let levels: [Level] = [
        Level(name: "Baby Brain", minScore: 0, maxScore: 199, image: "brain.head.profile"),
        Level(name: "Curious Kid", minScore: 200, maxScore: 399, image: "questionmark.circle"),
        Level(name: "Eager Student", minScore: 400, maxScore: 599, image: "book.fill"),
        Level(name: "Junior Scholar", minScore: 600, maxScore: 799, image: "graduationcap.fill"),
        Level(name: "Knowledge Explorer", minScore: 800, maxScore: 999, image: "map.fill"),
        Level(name: "Brainiac Beginner", minScore: 1000, maxScore: 1199, image: "sparkles"),
        Level(name: "Trivia Enthusiast", minScore: 1200, maxScore: 1399, image: "star.fill"),
        Level(name: "Quiz Whiz", minScore: 1400, maxScore: 1599, image: "bolt.fill"),
        Level(name: "Smarty Pants", minScore: 1600, maxScore: 1799, image: "crown.fill"),
        Level(name: "Bright Mind", minScore: 1800, maxScore: 1999, image: "lightbulb.fill"),
        Level(name: "Trivia Challenger", minScore: 2000, maxScore: 2399, image: "trophy.fill"),
        Level(name: "Clever Sage", minScore: 2400, maxScore: 2799, image: "wand.and.stars"),
        Level(name: "Mastermind", minScore: 2800, maxScore: 3199, image: "medal.fill"),
        Level(name: "Professor", minScore: 3200, maxScore: 3599, image: "books.vertical.fill"),
        Level(name: "Brainiac Genius", minScore: 3600, maxScore: 3999, image: "brain"),
        Level(name: "Einstein", minScore: 4000, maxScore: Int.max, image: "atom")
    ]
    
    @Published var currentTotalScore: Int {
        didSet {
            UserDefaults.standard.set(currentTotalScore, forKey: "totalScore")
        }
    }
    
    init() {
        self.currentTotalScore = UserDefaults.standard.integer(forKey: "totalScore")
    }
    
    func getCurrentLevel() -> Level {
        return levels.first { level in
            currentTotalScore >= level.minScore && currentTotalScore <= level.maxScore
        } ?? levels[0]
    }
    
    func getNextLevel() -> Level? {
        let currentLevel = getCurrentLevel()
        return levels.first { $0.minScore > currentLevel.maxScore }
    }
    
    func getProgressToNextLevel() -> Double {
        let currentLevel = getCurrentLevel()
        let scoreInLevel = Double(currentTotalScore - currentLevel.minScore)
        let levelRange = Double(currentLevel.maxScore - currentLevel.minScore)
        return scoreInLevel / levelRange
    }
    
    func addScore(_ score: Int) {
        let oldLevel = getCurrentLevel()
        currentTotalScore += score
        let newLevel = getCurrentLevel()
        
        if newLevel.name != oldLevel.name {
            NotificationCenter.default.post(name: .levelUp, object: nil)
        }
    }
}

extension Notification.Name {
    static let levelUp = Notification.Name("levelUp")
}
