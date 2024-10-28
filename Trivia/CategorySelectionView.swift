import SwiftUI

struct CategorySelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimeLimit: Int? = nil
    @State private var showingGameView = false
    @State private var selectedCategory: QuizCategory?
    
    // Add specific time options
    let timeOptions = [30, 60, 120, nil] // nil represents no time limit
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Time Selection
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Select Time Limit")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                        
                        HStack(spacing: 15) {
                            ForEach(timeOptions, id: \.self) { seconds in
                                TimeOptionButton(
                                    seconds: seconds,
                                    isSelected: selectedTimeLimit == seconds
                                ) {
                                    selectedTimeLimit = seconds
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Categories Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        ForEach(QuizCategory.allCases) { category in
                            CategoryCard(category: category, isSelected: selectedCategory == category)
                                .onTapGesture {
                                    selectedCategory = category
                                    showingGameView = true
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "2E1C4A"),
                        Color(hex: "0F1C4D")
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Choose Category")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showingGameView) {
                if let category = selectedCategory {
                    GameView(
                        category: category,
                        timeLimit: selectedTimeLimit
                    )
                }
            }
        }
    }
}

// Time Option Button Component
struct TimeOptionButton: View {
    let seconds: Int?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(seconds.map { "\($0)s" } ?? "∞")
                .font(.headline)
                .foregroundColor(isSelected ? .black : .white)
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color(hex: "00E5FF") : Color(hex: "2E1C4A").opacity(0.6))
                )
        }
    }
}

// Game View that uses the time limit
struct GameView: View {
    let category: QuizCategory
    let timeLimit: Int?
    @StateObject private var game = GameLogic()
    @State private var timeRemaining: Int
    @State private var timer: Timer?
    @State private var isTimeUp = false
    @Environment(\.dismiss) private var dismiss
    
    init(category: QuizCategory, timeLimit: Int?) {
        self.category = category
        self.timeLimit = timeLimit
        _timeRemaining = State(initialValue: timeLimit ?? 0)
    }
    
    var body: some View {
        VStack {
            if timeLimit != nil {
                Text(timeRemaining.formatted())
                    .font(.largeTitle)
                    .foregroundColor(timeRemaining < 10 ? .red : .white)
            }
            
            ContentView()
        }
        .onAppear {
            startTimer()
            game.startNewGame(category: category)
        }
        .onDisappear {
            timer?.invalidate()
        }
        .alert("Time's Up!", isPresented: $isTimeUp) {
            Button("OK", role: .cancel) {
                game.endGame()
            }
        }
    }
    
    private func startTimer() {
        guard timeLimit != nil else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                isTimeUp = true
            }
        }
    }
}
