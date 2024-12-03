import SwiftUI
import FirebaseAuth

struct GameView: View {
    let gameMode: GameMode
    let timeLimit: Int?
    @StateObject private var game = GameLogic()
    @State private var timeRemaining: Int
    @State private var timer: Timer?
    @State private var isTimeUp = false
    @State private var selectedAnswer: Int?
    @State private var showingFeedback = false
    @Environment(\.dismiss) var dismiss
    @State private var showingSummary = false
    @State private var userAnswers: [Int] = []
    @StateObject private var premiumManager = PremiumManager.shared
    @State private var showingPremiumStore = false
    @StateObject private var levelManager = LevelManager.shared
    
    var gameStats: GameStats {
        levelManager.gameStats
    }
    
    init(gameMode: GameMode, timeLimit: Int?) {
        self.gameMode = gameMode
        self.timeLimit = timeLimit
        _timeRemaining = State(initialValue: timeLimit ?? 0)
    }
    
    var body: some View {
        Group {
            if gameMode.requiresPremium && !premiumManager.isPremiumFeatureAvailable() {
                // Show premium required view
                VStack {
                    Text("Premium Required")
                        .font(.title)
                        .foregroundColor(.white)
                    Text("This game mode requires premium access")
                        .foregroundColor(.gray)
                    Button("Unlock Premium") {
                        showingPremiumStore = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding()
                }
                .padding()
                .sheet(isPresented: $showingPremiumStore) {
                    PremiumStoreView()
                }
            } else {
                ZStack {
                    // Background gradient consistent with game mode selection
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "2E1C4A"),
                            Color(hex: "0F1C4D")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // Top Navigation Bar
                        HStack {
                            Button(action: { dismiss() }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }
                                .foregroundColor(Color(hex: "00E5FF"))
                            }
                            
                            Spacer()
                            
                            if gameMode == .timeAttack {
                                Text(timeRemaining.formatted())
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(Color(hex: "00E5FF"))
                                    .frame(width: 60)
                                    .padding(.horizontal, 8)
                                    .background(
                                        Capsule()
                                            .fill(Color.white.opacity(0.1))
                                    )
                            }
                            
                            AudioControlsView()
                        }
                        .padding()
                        
                        // Progress Bar and Score
                        HStack {
                            Text("Question \(game.questionIndex + 1)/\(game.getTotalQuestions())")
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                Text("\(game.score)")
                            }
                            .foregroundColor(Color(hex: "00E5FF"))
                        }
                        .font(.headline)
                        .padding(.horizontal)
                        
                        // Progress Bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: geometry.size.width, height: 2)
                                
                                Rectangle()
                                    .fill(Color(hex: "00E5FF"))
                                    .frame(
                                        width: max(0, min(geometry.size.width, 
                                            geometry.size.width * CGFloat(game.questionIndex + 1) / CGFloat(max(1, game.getTotalQuestions()))
                                        )),
                                        height: 2
                                    )
                            }
                        }
                        .frame(height: 2)
                        .padding(.horizontal)
                        
                        // Spacer to push content down
                        Spacer()
                        
                        if !game.currentQuestions.isEmpty {
                            // Question Card in the middle
                            VStack(spacing: 15) {
                                Text(game.currentQuestions[game.questionIndex].text)
                                    .font(.title3)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 25)
                                    .padding(.vertical, 30)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white.opacity(0.05))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .padding(.horizontal)
                            }
                            
                            Spacer()
                            
                            // Answer buttons at the bottom for easy thumb reach
                            VStack(spacing: 16) {
                                ForEach(0..<game.currentQuestions[game.questionIndex].answers.count, id: \.self) { index in
                                    AnswerButton(
                                        text: game.currentQuestions[game.questionIndex].answers[index],
                                        isSelected: selectedAnswer == index,
                                        isCorrect: showingFeedback ? (index == game.currentQuestions[game.questionIndex].correctAnswer) : nil,
                                        isWrong: showingFeedback ? (selectedAnswer == index && index != game.currentQuestions[game.questionIndex].correctAnswer) : nil
                                    ) {
                                        if !showingFeedback {
                                            selectedAnswer = index
                                            showingFeedback = true
                                            userAnswers.append(index)
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                game.checkAnswer(index)
                                                selectedAnswer = nil
                                                showingFeedback = false
                                                
                                                // Check if this was the last question
                                                if game.questionIndex >= game.getTotalQuestions() - 1 {
                                                    game.endGame()
                                                    handleGameOver()
                                                    showingSummary = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                        }
                    }
                }
                .onAppear {
                    if let user = Auth.auth().currentUser {
                        print("Current user ID: \(user.uid)")
                    } else {
                        print("No authenticated user!")
                    }
                    startTimer()
                    game.startNewGame(mode: gameMode)
                }
                .onDisappear {
                    timer?.invalidate()
                }
                .sheet(isPresented: $showingSummary, onDismiss: {
                    dismiss()
                }) {
                    GameSummaryView(
                        questions: game.currentQuestions,
                        userAnswers: userAnswers,
                        score: game.score,
                        totalQuestions: game.getTotalQuestions(),
                        gameMode: gameMode
                    )
                }
            }
        }
    }
    
    private func startTimer() {
        guard timeLimit != nil else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                // Add visual feedback when time is running low
                if timeRemaining <= 10 {
                    HapticManager.shared.warning()
                }
            } else {
                timer?.invalidate()
                withAnimation {
                    isTimeUp = true
                    game.endGame()
                }
            }
        }
    }
    
    private func handleGameOver() {
        // Calculate accuracy
        let totalQuestions = game.getTotalQuestions()
        let correctAnswers = game.score
        let accuracy = Double(correctAnswers) / Double(totalQuestions) * 100
        
        // Update total score in LevelManager
        levelManager.addScore(game.score, accuracy: accuracy)
        
        // Update leaderboard with total score
        LeaderboardManager.shared.updateUserScore(
            score: levelManager.currentTotalScore, // Use total score instead of game score
            level: levelManager.getCurrentLevel().name,
            accuracy: accuracy,
            gamesPlayed: gameStats.totalGamesPlayed + 1
        )
    }
}

#Preview {
    GameView(gameMode: .timeAttack, timeLimit: 60)
} 
