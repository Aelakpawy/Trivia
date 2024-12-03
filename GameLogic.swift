import Foundation
import SwiftUI

// Add this struct at the top of the file, before the GameLogic class
struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var value: UInt64
    
    init(seed: TimeInterval) {
        // Convert the TimeInterval (Double) to UInt64 for consistent results
        self.value = UInt64(bitPattern: Int64(seed))
    }
    
    mutating func next() -> UInt64 {
        value ^= value << 13
        value ^= value >> 7
        value ^= value << 17
        return value
    }
}

class GameLogic: ObservableObject {
    @Published private(set) var score = 0
    @Published private(set) var questionIndex = 0
    @Published private(set) var showingScore = false
    @Published private(set) var currentQuestions: [Question] = []
    @Published private(set) var highScore: Int
    @Published private(set) var currentGameMode: GameMode = .classic
    @Published private(set) var isGameInProgress = false
    
    private let audioManager = AudioManager.shared
    private let levelManager = LevelManager.shared
    
    // Office-themed questions
    private let officeQuestions = [
        Question(
            text: "What is Michael Scott's middle name?",
            answers: ["Gary", "Kurt", "Steven", "John"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What does Dwight grow on his farm?",
            answers: ["Corn", "Wheat", "Beets", "Potatoes"],
            correctAnswer: 2,
            difficulty: .easy
        ),
        Question(
            text: "What is the name of Pam and Jim's first child?",
            answers: ["Cecelia", "Cece", "Penny", "Sylvia"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        Question(
            text: "What is the name of Jan's candle company?",
            answers: ["Serenity by Jan", "Jan's Candles", "Scents by Jan", "Jan's Scents"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What is Stanley's favorite day of the week?",
            answers: ["Monday", "Friday", "Pretzel Day", "Sunday"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        Question(
            text: "What is the name of Angela's favorite cat?",
            answers: ["Bandit", "Sprinkles", "Princess Lady", "Mr. Ash"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "What is Dwight's title at Schrute Farms?",
            answers: ["Owner", "Manager", "Farmer", "Agrotourism Director"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What is Kevin's famous chili recipe's secret ingredient?",
            answers: ["Undercooking the onions", "Extra spices", "Special beans", "Family recipe"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "What is the name of Michael's screenplay?",
            answers: ["Threat Level Midnight", "Agent Michael Scarn", "Golden Face", "The Office"],
            correctAnswer: 0,
            difficulty: .easy
        ),
        Question(
            text: "What is Creed's real name in the show?",
            answers: ["William Charles", "Creed Bratton", "Jeff Bomondo", "Not Specified"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "What is the name of Dwight's martial arts instructor?",
            answers: ["Sensei Billy", "Sensei Ira", "Sensei Wilson", "Sensei Chuck"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "What is Andy Bernard's nickname for Jim?",
            answers: ["Big Tuna", "Slim Jim", "Halpert", "Jimmy"],
            correctAnswer: 0,
            difficulty: .easy
        ),
        Question(
            text: "What college did Andy Bernard attend?",
            answers: ["Yale", "Harvard", "Cornell", "Princeton"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        Question(
            text: "What is the name of the company's security guard?",
            answers: ["Hank", "Frank", "Bill", "Steve"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What is Phyllis's maiden name?",
            answers: ["Lapin", "Vance", "Anderson", "Smith"],
            correctAnswer: 0,
            difficulty: .hard
        )
    ]
    
    init() {
        self.highScore = UserDefaults.standard.integer(forKey: "highScore")
        self.currentQuestions = []
    }
    
    private func getRandomQuestions(count: Int, includeOfficeQuestions: Bool = false) -> [Question] {
        // Filter questions based on whether Office questions should be included
        let availableQuestions = QuestionBank.allQuestions.filter { question in
            if !includeOfficeQuestions {
                // Exclude Office-themed questions
                return !question.text.contains("Michael") &&
                       !question.text.contains("Dwight") &&
                       !question.text.contains("Jim") &&
                       !question.text.contains("Pam") &&
                       !question.text.contains("Andy") &&
                       !question.text.contains("Angela") &&
                       !question.text.contains("Oscar") &&
                       !question.text.contains("Stanley") &&
                       !question.text.contains("Creed") &&
                       !question.text.contains("Kevin") &&
                       !question.text.contains("Dunder") &&
                       !question.text.contains("Scranton") &&
                       !question.text.contains("Office")
            }
            return true
        }
        
        let shuffledQuestions = availableQuestions.shuffled()
        return Array(shuffledQuestions.prefix(count))
    }
    
    private func getWeeklyOfficeQuestions() -> [Question] {
        // Create a unique session identifier that changes more frequently
        let timestamp = Date().timeIntervalSince1970
        let sessionID = Int(timestamp) % 10000
        
        // Get previously shown questions for this session
        let shownQuestionsKey = "shownWeeklyQuestions"
        var shownQuestions = UserDefaults.standard.array(forKey: shownQuestionsKey) as? [String] ?? []
        
        // Get all office questions
        let officeQuestions = QuestionBank.allQuestions.filter { question in
            // Only include questions about The Office (checking for character names and show-specific terms)
            return question.text.contains("Michael") ||
                   question.text.contains("Dwight") ||
                   question.text.contains("Jim") ||
                   question.text.contains("Pam") ||
                   question.text.contains("Andy") ||
                   question.text.contains("Angela") ||
                   question.text.contains("Oscar") ||
                   question.text.contains("Stanley") ||
                   question.text.contains("Creed") ||
                   question.text.contains("Kevin") ||
                   question.text.contains("Dunder") ||
                   question.text.contains("Scranton") ||
                   question.text.contains("Office")
        }
        
        // Filter out recently shown questions
        let availableQuestions = officeQuestions.filter { question in
            !shownQuestions.contains(question.text)
        }
        
        // If we're running low on fresh questions, reset the shown questions
        if availableQuestions.count < 10 {
            shownQuestions = []
            UserDefaults.standard.set(shownQuestions, forKey: shownQuestionsKey)
            print("Reset shown questions due to low availability")
        }
        
        // Create a random number generator with the session ID
        var generator = SeededRandomNumberGenerator(seed: Double(sessionID))
        
        // Get questions, preferring unused ones but falling back to all if necessary
        let questionsToUse = availableQuestions.count >= 10 ? availableQuestions : officeQuestions
        let selectedQuestions = Array(questionsToUse.shuffled(using: &generator).prefix(10))
        
        // Update shown questions list
        shownQuestions.append(contentsOf: selectedQuestions.map { $0.text })
        if shownQuestions.count > officeQuestions.count / 2 {
            shownQuestions.removeFirst(officeQuestions.count / 4)
        }
        UserDefaults.standard.set(shownQuestions, forKey: shownQuestionsKey)
        
        print("Selected \(selectedQuestions.count) Office questions from pool of \(questionsToUse.count) available questions")
        print("Currently tracking \(shownQuestions.count) shown questions")
        
        return selectedQuestions
    }
    
    func startNewGame(mode: GameMode, playMusic: Bool = true) {
        print("Starting new game with mode: \(mode)")
        self.currentGameMode = mode
        
        switch mode {
        case .classic:
            currentQuestions = getRandomQuestions(count: 10, includeOfficeQuestions: false)
            
        case .weeklyChallenge:
            currentQuestions = getWeeklyOfficeQuestions()
            print("Set \(currentQuestions.count) Office questions")
            
        case .timeAttack:
            currentQuestions = getRandomQuestions(count: 20, includeOfficeQuestions: false)
            
        case .iqTest:
            currentQuestions = getIQTestQuestions()
            
        case .challenge:
            currentQuestions = getRandomQuestions(count: 10, includeOfficeQuestions: false)
        }
        
        // Debug print
        print("Current questions count: \(currentQuestions.count)")
        if currentQuestions.isEmpty {
            print("Warning: No questions loaded!")
        }
        
        score = 0
        questionIndex = 0
        showingScore = false
        isGameInProgress = true
        
        if playMusic {
            audioManager.setGameInProgress(true)
        }
    }
    
    @MainActor func checkAnswer(_ selectedAnswer: Int) {
        guard questionIndex < currentQuestions.count else {
            print("Warning: Attempting to check answer when no questions remain")
            endGame()
            return
        }
        
        if selectedAnswer == currentQuestions[questionIndex].correctAnswer {
            // Special scoring for IQ test mode
            if currentGameMode == .iqTest {
                score += 10  // Base IQ points per correct answer
            } else {
                score += 1
            }
            audioManager.playCorrectSound()
        } else {
            audioManager.playWrongSound()
        }
        
        // Move to next question or end game
        if questionIndex + 1 < getTotalQuestions() {
            questionIndex += 1
        } else {
            if currentGameMode == .iqTest {
                // Calculate final IQ score (base 100 + bonus points)
                let finalScore = 100 + (score * 3)
                IQTestManager.shared.saveResult(finalScore, category: "General IQ")
            }
            endGame()
        }
    }
    
    func getCurrentQuestion() -> Question {
        guard !currentQuestions.isEmpty, questionIndex >= 0, questionIndex < currentQuestions.count else {
            // Return a default question or restart the game if we're out of bounds
            print("Warning: Question index out of bounds, resetting game")
            restart()
            return currentQuestions[0]
        }
        return currentQuestions[questionIndex]
    }
    
    func getTotalQuestions() -> Int {
        return currentQuestions.count
    }
    
    func isGameOver() -> Bool {
        return showingScore
    }

    
    func endGame() {
        showingScore = true
        isGameInProgress = false
        
        audioManager.setGameInProgress(false)
        audioManager.stopBackgroundMusic()
        audioManager.playGameOverSound()
        
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "highScore")
        }
        
        let accuracy = currentQuestions.isEmpty ? 0.0 : Double(score) / Double(currentQuestions.count)
        
        let categoryBonus = currentGameMode == .classic ? 1 : 1.5
        let points = Int(Double(score) * 10 * categoryBonus)
        
        levelManager.addScore(points, accuracy: accuracy)
        
        saveScore(score: points, category: currentGameMode)
    }
    
    func restart() {
        // Reset game state
        score = 0
        questionIndex = 0
        showingScore = false
        isGameInProgress = true
        
        // Ensure we have questions
        if currentQuestions.isEmpty {
            startNewGame(mode: currentGameMode, playMusic: true)
        }
    }
    
    // MARK: - Score Management
    func saveScore(score: Int, category: GameMode) {
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
    func hasEnoughQuestions(for category: GameMode) -> Bool {
        let questions = getRandomQuestions(count: 10)
        return questions.count >= 10
    }
    
    func getQuestionCount(for category: GameMode) -> Int {
        return getRandomQuestions(count: 10).count
    }
    
    func getHighScore(for category: GameMode) -> Int {
        return UserDefaults.standard.integer(forKey: "highScore_\(category.rawValue)")
    }
    
    private func updateHighScore(for category: GameMode) {
        let currentCategoryHighScore = getHighScore(for: category)
        if score > currentCategoryHighScore {
            UserDefaults.standard.set(score, forKey: "highScore_\(category.rawValue)")
        }
        
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "highScore")
        }
    }
    
    func getAvailableCategories() -> [GameMode] {
        return GameMode.allCases.filter { hasEnoughQuestions(for: $0) }
    }
    
    private let premiumManager = PremiumManager.shared
    
    func getAvailableQuestions() -> [Question] {
        if premiumManager.isPremiumFeatureAvailable() {
            return QuestionBank.allQuestions
        } else {
            // Return only non-premium questions
            return QuestionBank.allQuestions.filter { $0.difficulty != .hard }
        }
    }
    
    private func getIQTestQuestions() -> [Question] {
        let allIQQuestions = [
            // Pattern Sequences
            Question(
                text: "Complete the sequence: 2, 4, 8, 16, ...",
                answers: ["24", "32", "28", "30"],
                correctAnswer: 1,
                difficulty: .hard
            ),
            Question(
                text: "What comes next: 3, 6, 12, 24, ...",
                answers: ["36", "48", "30", "42"],
                correctAnswer: 1,
                difficulty: .hard
            ),
            Question(
                text: "Complete: 1, 3, 6, 10, 15, ...",
                answers: ["21", "18", "20", "25"],
                correctAnswer: 0,
                difficulty: .hard
            ),
            
            // Logical Reasoning
            Question(
                text: "If all Zorks are Yops and no Yops are Xims, then:",
                answers: ["All Zorks are Xims", "No Zorks are Xims", "Some Zorks are Xims", "Cannot determine"],
                correctAnswer: 1,
                difficulty: .hard
            ),
            Question(
                text: "If no heroes are cowards, and John is a hero, then:",
                answers: ["John is brave", "John is not a coward", "John might be a coward", "Cannot determine"],
                correctAnswer: 1,
                difficulty: .hard
            ),
            
            // Mathematical Reasoning
            Question(
                text: "If 5 cats catch 5 mice in 5 minutes, how many cats catch 100 mice in 100 minutes?",
                answers: ["5 cats", "100 cats", "20 cats", "25 cats"],
                correctAnswer: 0,
                difficulty: .hard
            ),
            Question(
                text: "A clock shows 3:15. What is the angle between the hour and minute hands?",
                answers: ["7.5°", "67.5°", "37.5°", "97.5°"],
                correctAnswer: 1,
                difficulty: .hard
            ),
            
            // Spatial Reasoning
            Question(
                text: "Which shape would complete the pattern? ○ □ △ ○ □ △ ○ □ ...",
                answers: ["○", "□", "△", "⬡"],
                correctAnswer: 2,
                difficulty: .medium
            ),
            Question(
                text: "If a cube is painted red and cut into 27 smaller equal cubes, how many small cubes have exactly two red faces?",
                answers: ["8", "12", "24", "4"],
                correctAnswer: 1,
                difficulty: .hard
            ),
            
            // Verbal Analogies
            Question(
                text: "FISH : SCHOOL :: WOLF : ?",
                answers: ["Den", "Pack", "Forest", "Hunt"],
                correctAnswer: 1,
                difficulty: .medium
            ),
            Question(
                text: "NEEDLE : THREAD :: PEN : ?",
                answers: ["Write", "Paper", "Ink", "Book"],
                correctAnswer: 2,
                difficulty: .medium
            ),
            
            // Number Series
            Question(
                text: "What number comes next: 2, 6, 12, 20, 30, ...",
                answers: ["42", "40", "36", "44"],
                correctAnswer: 0,
                difficulty: .hard
            ),
            Question(
                text: "Complete the series: 31, 29, 24, 22, 17, ...",
                answers: ["15", "12", "14", "16"],
                correctAnswer: 0,
                difficulty: .hard
            ),
            
            // Word Problems
            Question(
                text: "If yesterday was two days after Monday, what day is tomorrow?",
                answers: ["Thursday", "Friday", "Saturday", "Sunday"],
                correctAnswer: 1,
                difficulty: .medium
            ),
            Question(
                text: "A father is 4 times as old as his son. In 20 years, he'll be twice as old. How old is the son now?",
                answers: ["20", "15", "10", "25"],
                correctAnswer: 0,
                difficulty: .hard
            ),
            
            // Pattern Recognition
            Question(
                text: "Which number doesn't belong: 2, 3, 5, 7, 8, 11, 13",
                answers: ["2", "8", "11", "13"],
                correctAnswer: 1,
                difficulty: .medium
            ),
            Question(
                text: "What comes next: ▢△○ ▢▢△ ▢△△ ...",
                answers: ["▢○○", "▢▢○", "▢△○", "○△▢"],
                correctAnswer: 0,
                difficulty: .hard
            ),
            
            // Logical Deduction
            Question(
                text: "If A > B and B > C, which statement must be true?",
                answers: ["C > A", "A > C", "B > A", "None of these"],
                correctAnswer: 1,
                difficulty: .medium
            ),
            Question(
                text: "All mammals are warm-blooded. No reptiles are mammals. Therefore:",
                answers: ["All reptiles are cold-blooded", "Some reptiles are warm-blooded", "No reptiles are warm-blooded", "Cannot determine"],
                correctAnswer: 3,
                difficulty: .hard
            ),
            
            // Mathematical Patterns
            Question(
                text: "What is the sum of the first 5 even numbers?",
                answers: ["20", "30", "25", "15"],
                correctAnswer: 1,
                difficulty: .medium
            ),
            Question(
                text: "If a triangle has angles of 90° and 45°, what is the third angle?",
                answers: ["45°", "30°", "60°", "75°"],
                correctAnswer: 0,
                difficulty: .medium
            ),
            
            // Visual Patterns
            Question(
                text: "If HELLO = 8-5-12-12-15, what is WORLD?",
                answers: ["23-15-18-12-4", "22-15-17-12-4", "23-14-18-12-4", "23-15-18-11-4"],
                correctAnswer: 0,
                difficulty: .hard
            ),
            Question(
                text: "Which image would complete the pattern? 🌑 🌓 🌕 🌗 ...",
                answers: ["🌑", "🌓", "🌕", "🌗"],
                correctAnswer: 0,
                difficulty: .medium
            ),
            
            // Abstract Reasoning
            Question(
                text: "If Red + Blue = Purple, and Yellow + Blue = Green, then Red + Yellow = ?",
                answers: ["Orange", "Brown", "Purple", "Green"],
                correctAnswer: 0,
                difficulty: .medium
            ),
            Question(
                text: "In a foreign language, 'pix zur' means 'red ball', 'zur kel' means 'blue ball', what does 'pix' mean?",
                answers: ["ball", "red", "blue", "Cannot determine"],
                correctAnswer: 1,
                difficulty: .hard
            ),
            
            // Spatial Visualization
            Question(
                text: "How many squares are in a 3x3 grid?",
                answers: ["9", "14", "5", "12"],
                correctAnswer: 1,
                difficulty: .hard
            ),
            Question(
                text: "If you fold a square paper in half twice, how many layers will there be?",
                answers: ["2", "3", "4", "6"],
                correctAnswer: 2,
                difficulty: .medium
            ),
            
            // Critical Thinking
            Question(
                text: "If it takes 8 hours to dig a hole, how long does it take 4 people to dig half a hole?",
                answers: ["1 hour", "2 hours", "4 hours", "You can't dig half a hole"],
                correctAnswer: 3,
                difficulty: .medium
            ),
            Question(
                text: "A bat and ball cost $1.10. The bat costs $1 more than the ball. How much is the ball?",
                answers: ["$0.10", "$0.05", "$0.15", "$0.20"],
                correctAnswer: 1,
                difficulty: .hard
            ),
            
            // Additional questions...
            Question(
                text: "What number should replace the question mark: 8 : 4 :: 10 : ?",
                answers: ["5", "6", "4", "8"],
                correctAnswer: 0,
                difficulty: .medium
            ),
            Question(
                text: "Complete: FACE : CAFE :: DEAR : ?",
                answers: ["READ", "DARE", "RAID", "REAR"],
                correctAnswer: 1,
                difficulty: .hard
            ),
            Question(
                text: "If you rearrange the letters 'CIFAIPC', you get the name of a(n):",
                answers: ["Country", "Animal", "Ocean", "City"],
                correctAnswer: 2,
                difficulty: .hard
            ),
            Question(
                text: "Which word is the odd one out?",
                answers: ["Swift", "Eagle", "Penguin", "Ostrich"],
                correctAnswer: 0,
                difficulty: .medium
            ),
            Question(
                text: "Complete the analogy: Tree : Forest :: Page : ?",
                answers: ["Paper", "Book", "Write", "Read"],
                correctAnswer: 1,
                difficulty: .medium
            ),
            Question(
                text: "If you count from 1 to 100, how many 7's will you write?",
                answers: ["19", "20", "10", "11"],
                correctAnswer: 1,
                difficulty: .hard
            ),
            Question(
                text: "What letter comes next: A, D, G, J, ?",
                answers: ["L", "M", "N", "O"],
                correctAnswer: 1,
                difficulty: .medium
            ),
            Question(
                text: "If 5 people can do a job in 3 hours, how long will it take 15 people?",
                answers: ["1 hour", "9 hours", "6 hours", "3 hours"],
                correctAnswer: 0,
                difficulty: .hard
            ),
            Question(
                text: "Which fraction is the largest?",
                answers: ["3/4", "5/6", "7/8", "11/12"],
                correctAnswer: 3,
                difficulty: .hard
            ),
            Question(
                text: "What comes next in the sequence: 1, 11, 21, 1211, ?",
                answers: ["2221", "111221", "22111", "11121"],
                correctAnswer: 1,
                difficulty: .hard
            ),
            Question(
                text: "How many triangles are in this sequence: △ △△ △△△ △△△△",
                answers: ["10", "8", "12", "9"],
                correctAnswer: 0,
                difficulty: .medium
            ),
            Question(
                text: "Complete the sequence: 2, 3, 5, 9, 17, ?",
                answers: ["33", "34", "31", "35"],
                correctAnswer: 0,
                difficulty: .hard
            ),
            Question(
                text: "If a wheel makes 10 revolutions in 5 seconds, how many will it make in 30 seconds?",
                answers: ["50", "60", "40", "45"],
                correctAnswer: 1,
                difficulty: .medium
            ),
            Question(
                text: "Which number is the odd one out: 125, 216, 343, 512, 729",
                answers: ["125", "216", "512", "729"],
                correctAnswer: 2,
                difficulty: .hard
            ),
            Question(
                text: "What letter should appear twice in this sequence: M T W T F S ?",
                answers: ["S", "M", "T", "F"],
                correctAnswer: 2,
                difficulty: .medium
            )
        ]
        
        // Return 10 random questions from the pool
        return Array(allIQQuestions.shuffled().prefix(10))
    }
}

// Add this to your Models file if not already present
struct PlayerScore: Codable, Identifiable {
    var id = UUID()
    let username: String
    let score: Int
    let category: GameMode
    let date: Date
}
