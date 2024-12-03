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
    let image: String
    let requirements: String
    let perks: [String]
}

class LevelManager: ObservableObject {
    static let shared = LevelManager()
    
    let levels: [Level] = [
        Level(
            name: "Triviaholic Novice",
            minScore: 0,
            maxScore: 499,
            image: "brain.head.profile",
            requirements: "Start your journey",
            perks: ["Access to basic questions"]
        ),
        Level(
            name: "Curious Kid",
            minScore: 500,
            maxScore: 999,
            image: "questionmark.circle",
            requirements: "Score 500 points with 70% accuracy",
            perks: ["Unlock daily challenges", "New question categories"]
        ),
        Level(
            name: "Eager Student",
            minScore: 1000,
            maxScore: 1999,
            image: "book.fill",
            requirements: "Complete 20 games with 75% accuracy",
            perks: ["Access to medium difficulty", "Special badges"]
        ),
        Level(
            name: "Junior Scholar",
            minScore: 2000,
            maxScore: 3499,
            image: "graduationcap.fill",
            requirements: "Win 5 challenges, 80% accuracy",
            perks: ["Challenge mode unlocked", "Profile customization"]
        ),
        Level(
            name: "Knowledge Explorer",
            minScore: 3500,
            maxScore: 5999,
            image: "map.fill",
            requirements: "Complete 50 daily challenges",
            perks: ["Expert categories unlocked", "Special effects"]
        ),
        Level(
            name: "Brainiac Beginner",
            minScore: 6000,
            maxScore: 9999,
            image: "sparkles",
            requirements: "85% accuracy in 100 games",
            perks: ["Create custom challenges", "Unique animations"]
        ),
        Level(
            name: "Triviaholic Enthusiast",
            minScore: 10000,
            maxScore: 14999,
            image: "star.fill",
            requirements: "Win 20 challenges, maintain 85% accuracy",
            perks: ["Premium question sets", "Custom badges"]
        ),
        Level(
            name: "Quiz Whiz",
            minScore: 15000,
            maxScore: 24999,
            image: "bolt.fill",
            requirements: "90% accuracy in Time Attack mode",
            perks: ["Create tournaments", "Special effects"]
        ),
        Level(
            name: "Smarty Pants",
            minScore: 25000,
            maxScore: 39999,
            image: "crown.fill",
            requirements: "Complete 200 daily challenges",
            perks: ["Exclusive categories", "Custom themes"]
        ),
        Level(
            name: "Bright Mind",
            minScore: 40000,
            maxScore: 59999,
            image: "lightbulb.fill",
            requirements: "95% accuracy in 500 games",
            perks: ["Create leagues", "Special animations"]
        ),
        Level(
            name: "Triviaholic Challenger",
            minScore: 60000,
            maxScore: 89999,
            image: "trophy.fill",
            requirements: "Win 100 challenges",
            perks: ["Host tournaments", "Unique effects"]
        ),
        Level(
            name: "Clever Sage",
            minScore: 90000,
            maxScore: 129999,
            image: "wand.and.stars",
            requirements: "1000 games with 95% accuracy",
            perks: ["Create custom modes", "Special powers"]
        ),
        Level(
            name: "Mastermind",
            minScore: 130000,
            maxScore: 179999,
            image: "medal.fill",
            requirements: "Win 500 challenges",
            perks: ["Design questions", "Ultimate badges"]
        ),
        Level(
            name: "Professor",
            minScore: 180000,
            maxScore: 249999,
            image: "books.vertical.fill",
            requirements: "2000 games with 97% accuracy",
            perks: ["Create tournaments", "Special effects"]
        ),
        Level(
            name: "Brainiac Genius",
            minScore: 250000,
            maxScore: 349999,
            image: "brain",
            requirements: "Win 1000 challenges",
            perks: ["Create special events", "Unique powers"]
        ),
        Level(
            name: "Einstein",
            minScore: 350000,
            maxScore: Int.max,
            image: "atom",
            requirements: "5000 games with 98% accuracy",
            perks: ["Legendary status", "All features unlocked"]
        )
    ]
    
    @Published var currentTotalScore: Int {
        didSet {
            UserDefaults.standard.set(currentTotalScore, forKey: "totalScore")
            checkLevelUp(oldScore: oldValue, newScore: currentTotalScore)
        }
    }
    
    @Published var gameStats: GameStats {
        didSet {
            if let encoded = try? JSONEncoder().encode(gameStats) {
                UserDefaults.standard.set(encoded, forKey: "gameStats")
            }
        }
    }
    
    init() {
        self.currentTotalScore = UserDefaults.standard.integer(forKey: "totalScore")
        
        if let data = UserDefaults.standard.data(forKey: "gameStats"),
           let stats = try? JSONDecoder().decode(GameStats.self, from: data) {
            self.gameStats = stats
        } else {
            self.gameStats = GameStats()
        }
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
        
        let progress = scoreInLevel / levelRange
        return max(0, min(1, progress))
    }
    
    func addScore(_ score: Int, accuracy: Double) {
        let oldLevel = getCurrentLevel()
        
        // Update game stats
        gameStats.totalGamesPlayed += 1
        gameStats.averageAccuracy = (gameStats.averageAccuracy * Double(gameStats.totalGamesPlayed - 1) + accuracy) / Double(gameStats.totalGamesPlayed)
        
        // Apply score multiplier based on accuracy
        let multiplier = getScoreMultiplier(accuracy: accuracy)
        let adjustedScore = Int(Double(score) * multiplier)
        
        currentTotalScore += adjustedScore
        
        let newLevel = getCurrentLevel()
        if newLevel.name != oldLevel.name {
            NotificationCenter.default.post(
                name: .levelUp,
                object: nil,
                userInfo: ["newLevel": newLevel]
            )
        }
    }
    
    private func getScoreMultiplier(accuracy: Double) -> Double {
        switch accuracy {
        case 0.95...1.0:   return 2.0    // Perfect performance
        case 0.90..<0.95:  return 1.5    // Excellent
        case 0.80..<0.90:  return 1.2    // Good
        case 0.70..<0.80:  return 1.0    // Average
        case 0.60..<0.70:  return 0.8    // Below average
        default:           return 0.5    // Poor
        }
    }
    
    private func checkLevelUp(oldScore: Int, newScore: Int) {
        let oldLevel = levels.first { oldScore >= $0.minScore && oldScore <= $0.maxScore }
        let newLevel = levels.first { newScore >= $0.minScore && newScore <= $0.maxScore }
        
        if oldLevel?.name != newLevel?.name {
            HapticManager.shared.success()
            // You could add additional level-up rewards here
        }
    }
}

struct GameStats: Codable {
    var totalGamesPlayed: Int = 0
    var averageAccuracy: Double = 0.0
    var challengesWon: Int = 0
    var dailyChallengesCompleted: Int = 0
    var timeAttackHighScore: Int = 0
    var iqTestHighScore: Int = 0
    var iqTestAverage: Double = 0.0
    var iqTestsCompleted: Int = 0
}
