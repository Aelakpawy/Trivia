import SwiftUI

struct ContentView: View {
    @StateObject private var game = GameLogic()
    @StateObject private var levelManager = LevelManager.shared
    @State private var showingLevelUpAlert = false
    @State private var newLevelName = ""
    @State private var showingCategorySelection = true
    @Environment(\.dismiss) private var dismiss
    @State private var showingLeaderboard = false
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "2E1C4A"),
                    Color(hex: "0F1C4D")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Content
            VStack(spacing: 20) {
                if game.isGameOver() {
                    gameOverView
                } else {
                    gamePlayView
                }
            }
            .padding()
        }
        .onAppear {
            setupLevelUpNotification()
        }
        .alert("Level Up!", isPresented: $showingLevelUpAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Congratulations! You've reached \(newLevelName)!")
        }
        .fullScreenCover(isPresented: $showingLeaderboard) {
            LeaderboardView()
        }
    }
    
    private var gameOverView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Game Over!")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            
            Text("Your score: \(game.score) out of \(game.getTotalQuestions())")
                .font(.title2)
                .foregroundColor(.white)
            
            if game.score > game.highScore {
                Text("New High Score! 🎉")
                    .foregroundColor(Color(hex: "00E5FF"))
                    .font(.title3)
                    .padding(.top, 5)
            }
            
            Text("High Score: \(game.highScore)")
                .font(.subheadline)
                .foregroundColor(Color(hex: "B4A5FF"))
                .padding(.top, 5)
            
            LevelProgressView()
                .padding(.top, 20)
            
            // Navigation Buttons
            VStack(spacing: 15) {
                Button("Play Again") {
                    game.restart()
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button("Change Category") {
                    dismiss()
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Button("View Leaderboard") {
                    showingLeaderboard = true
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Button("Share Score") {
                    shareScore()
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Button("Back to Home") {
                    dismiss()
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
        }
    }
    
    private func setupLevelUpNotification() {
        // Your implementation here
    }
    
    private func shareScore() {
        let scoreText = "I scored \(game.score) out of \(game.getTotalQuestions()) in \(game.currentCategory.rawValue) category on Trivia Master! Current level: \(levelManager.getCurrentLevel().name) 🎮🧠"
        
        let activityVC = UIActivityViewController(
            activityItems: [scoreText],
            applicationActivities: nil
        )
        
        // Get the window scene and present the share sheet
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let viewController = window.rootViewController {
            // For iPad: set the source view for the popover
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = window
                popover.sourceRect = CGRect(x: window.bounds.midX, y: window.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            viewController.present(activityVC, animated: true)
        }
    }
    
    private var gamePlayView: some View {
        VStack(spacing: 25) {
            scoreAndProgressView
                .padding(.top, 20)
            
            LevelProgressView()
                .padding(.horizontal)
            
            Spacer()
            
            questionView
                .padding(.horizontal)
            
            Spacer()
            
            answersView
                .padding(.bottom, 30)
        }
    }
    
    private var scoreAndProgressView: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Score: \(game.score)")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                AudioControlsView()
                Spacer()
                Text("Question \(game.questionIndex + 1)/\(game.getTotalQuestions())")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            
            ProgressView(value: Double(game.questionIndex + 1),
                        total: Double(game.getTotalQuestions()))
                .padding(.horizontal)
                .tint(Color(hex: "00E5FF"))
        }
    }
    
    private var questionView: some View {
        Text(game.getCurrentQuestion().text)
            .font(.title2)
            .bold()
            .padding(20)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(hex: "2E1C4A").opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(hex: "00E5FF").opacity(0.3), lineWidth: 1)
                    )
            )
    }
    
    private var answersView: some View {
        VStack(spacing: 12) {
            ForEach(0..<game.getCurrentQuestion().answers.count, id: \.self) { index in
                Button(action: {
                    game.checkAnswer(index)
                }) {
                    Text(game.getCurrentQuestion().answers[index])
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "00E5FF").opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(hex: "00E5FF").opacity(0.5), lineWidth: 1)
                                )
                        )
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.black)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "00E5FF"))
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(Color(hex: "00E5FF"))
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.clear)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "00E5FF"), lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
