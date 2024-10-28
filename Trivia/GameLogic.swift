import Foundation

import Foundation

class GameLogic: ObservableObject {
    @Published private(set) var score = 0
    @Published private(set) var questionIndex = 0
    @Published private(set) var showingScore = false
    @Published private(set) var currentQuestions: [Question] = []
    @Published private(set) var highScore: Int
    @Published private(set) var currentCategory: QuizCategory = .general
    @Published private(set) var isGameInProgress = false
    
    private let audioManager = AudioManager.shared
    private let levelManager = LevelManager.shared
    
    init() {
        self.highScore = UserDefaults.standard.integer(forKey: "highScore")
        // Remove audioManager.playBackgroundMusic() from here
        startNewGame(playMusic: false) // Add parameter to prevent music from playing on init
    }
    
    func startNewGame(category: QuizCategory = .general, playMusic: Bool = true) {
        self.currentCategory = category
        let filteredQuestions = filterQuestionsByCategory(category)
        currentQuestions = Array(filteredQuestions.shuffled().prefix(10))
        score = 0
        questionIndex = 0
        showingScore = false
        isGameInProgress = true
        
        // Only play music if explicitly requested (default is true)
        if playMusic {
            audioManager.playBackgroundMusic()
        }
    }
    
    private func filterQuestionsByCategory(_ category: QuizCategory) -> [Question] {
        if category == .general {
            return QuestionBank.allQuestions
        }
        return QuestionBank.allQuestions.filter { $0.category == category }
    }
    
    func checkAnswer(_ selectedAnswer: Int) {
        if selectedAnswer == currentQuestions[questionIndex].correctAnswer {
            score += 1
            audioManager.playCorrectSound()
        } else {
            audioManager.playWrongSound()
        }
        
        if questionIndex + 1 < getTotalQuestions() {
            questionIndex += 1
        } else {
            endGame()
        }
    }
    
    func getCurrentQuestion() -> Question {
        return currentQuestions[questionIndex]
    }
    
    func getTotalQuestions() -> Int {
        return min(10, currentQuestions.count)
    }
    
    func isGameOver() -> Bool {
        return showingScore
    }

    
    func endGame() {
        showingScore = true
        isGameInProgress = false // Add this line
        audioManager.stopBackgroundMusic()
        audioManager.playGameOverSound()
        
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "highScore")
        }
        
        let categoryBonus = currentCategory == .general ? 1 : 1.5
        let points = Int(Double(score) * 10 * categoryBonus)
        levelManager.addScore(points)
        
        saveScore(score: points, category: currentCategory)
    }
    
    func restart() {
        startNewGame(category: currentCategory, playMusic: true)
    }
    
    // MARK: - Score Management
    func saveScore(score: Int, category: QuizCategory) {
        let username = UserDefaults.standard.string(forKey: "username") ?? "Unknown Player"
        let newScore = PlayerScore(
            username: username,
            score: score,
            category: category,
            date: Date()
        )
        
        var scores = getStoredScores()
        scores.append(newScore)
        scores.sort { $0.score > $1.score }
        
        if let encoded = try? JSONEncoder().encode(scores) {
            UserDefaults.standard.set(encoded, forKey: "playerScores")
        }
    }
    
    func getStoredScores() -> [PlayerScore] {
        if let data = UserDefaults.standard.data(forKey: "playerScores"),
           let decoded = try? JSONDecoder().decode([PlayerScore].self, from: data) {
            return decoded
        }
        return []
    }
    
    // Helper Methods
    func hasEnoughQuestions(for category: QuizCategory) -> Bool {
        let questions = filterQuestionsByCategory(category)
        return questions.count >= 10
    }
    
    func getQuestionCount(for category: QuizCategory) -> Int {
        return filterQuestionsByCategory(category).count
    }
    
    func getHighScore(for category: QuizCategory) -> Int {
        return UserDefaults.standard.integer(forKey: "highScore_\(category.rawValue)")
    }
    
    private func updateHighScore(for category: QuizCategory) {
        let currentCategoryHighScore = getHighScore(for: category)
        if score > currentCategoryHighScore {
            UserDefaults.standard.set(score, forKey: "highScore_\(category.rawValue)")
        }
        
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "highScore")
        }
    }
    
    func getAvailableCategories() -> [QuizCategory] {
        return QuizCategory.allCases.filter { hasEnoughQuestions(for: $0) }
    }
}

// Add this to your Models file if not already present
struct PlayerScore: Codable, Identifiable {
    var id = UUID()
    let username: String
    let score: Int
    let category: QuizCategory
    let date: Date
}
