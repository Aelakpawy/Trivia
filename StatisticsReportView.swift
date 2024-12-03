import SwiftUI
import Charts

struct StatisticsReportView: View {
    @StateObject private var levelManager = LevelManager.shared
    @StateObject private var iqTestManager = IQTestManager.shared
    @ObservedObject private var game = GameLogic()
    
    // Sample data for graphs
    @State private var performanceData: [PerformanceData] = []
    @State private var categoryData: [CategoryPerformance] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Overall Progress Card
                ProgressOverviewCard(
                    totalScore: levelManager.currentTotalScore,
                    currentLevel: levelManager.getCurrentLevel(),
                    nextLevel: levelManager.getNextLevel(),
                    progress: levelManager.getProgressToNextLevel()
                )
                
                // Performance Graph
                PerformanceGraphCard(data: performanceData)
                
                // Category Performance
                CategoryPerformanceCard(data: categoryData)
                
                // IQ Test Results
                IQTestResultsCard(results: iqTestManager.results)
                
                // Detailed Statistics
                DetailedStatsCard(gameStats: levelManager.gameStats)
                
                // Recent Games History
                RecentGamesCard(scores: game.getStoredScores())
            }
            .padding()
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
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        // Load sample performance data
        performanceData = generatePerformanceData()
        categoryData = generateCategoryData()
    }
}

// MARK: - Supporting Views

struct ProgressOverviewCard: View {
    let totalScore: Int
    let currentLevel: Level
    let nextLevel: Level?
    let progress: Double
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Current Level")
                        .foregroundColor(.gray)
                    Text(currentLevel.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("\(totalScore)")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(hex: "00E5FF"))
            }
            
            if let next = nextLevel {
                ProgressView(value: progress) {
                    HStack {
                        Text("Next: \(next.name)")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(next.minScore - totalScore) points to go")
                            .foregroundColor(.gray)
                    }
                    .font(.caption)
                }
                .tint(Color(hex: "00E5FF"))
            }
        }
        .padding()
        .glassBackground()
    }
}

struct PerformanceGraphCard: View {
    let data: [PerformanceData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Performance Trend")
                .font(.headline)
                .foregroundColor(.white)
            
            Chart(data) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Score", item.score)
                )
                .foregroundStyle(Color(hex: "00E5FF"))
                
                AreaMark(
                    x: .value("Date", item.date),
                    y: .value("Score", item.score)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(hex: "00E5FF").opacity(0.3),
                            Color(hex: "00E5FF").opacity(0.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .glassBackground()
    }
}

struct CategoryPerformanceCard: View {
    let data: [CategoryPerformance]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Category Performance")
                .font(.headline)
                .foregroundColor(.white)
            
            Chart(data) { item in
                BarMark(
                    x: .value("Category", item.category),
                    y: .value("Accuracy", item.accuracy)
                )
                .foregroundStyle(Color(hex: "00E5FF"))
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .glassBackground()
    }
}

struct IQTestResultsCard: View {
    let results: [IQTestResult]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("IQ Test Performance")
                .font(.headline)
                .foregroundColor(.white)
            
            if results.isEmpty {
                EmptyStateView(
                    icon: "brain.head.profile",
                    message: "No IQ Tests Taken",
                    description: "Complete an IQ test to see your results here"
                )
            } else {
                VStack(spacing: 20) {
                    // Average Score Section
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Average Score")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("\(Int(results.map { Double($0.score) }.reduce(0, +) / Double(results.count)))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Image(systemName: "brain.head.profile")
                            .font(.title)
                            .foregroundColor(Color(hex: "00E5FF"))
                    }
                    
                    Divider()
                        .background(Color.gray.opacity(0.3))
                    
                    // Recent Tests Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Tests")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        ForEach(results.suffix(3)) { result in
                            HStack {
                                Text(result.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("Score: \(result.score)")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                        }
                    }
                    
                    Divider()
                        .background(Color.gray.opacity(0.3))
                    
                    // Statistics Section
                    HStack(spacing: 20) {
                        StatBox(
                            title: "Highest",
                            value: "\(results.map { $0.score }.max() ?? 0)",
                            icon: "arrow.up.circle.fill",
                            color: Color(hex: "4CAF50")
                        )
                        
                        StatBox(
                            title: "Lowest",
                            value: "\(results.map { $0.score }.min() ?? 0)",
                            icon: "arrow.down.circle.fill",
                            color: Color(hex: "FF6B6B")
                        )
                        
                        StatBox(
                            title: "Total Tests",
                            value: "\(results.count)",
                            icon: "number.circle.fill",
                            color: Color(hex: "00E5FF")
                        )
                    }
                }
            }
        }
        .padding()
        .glassBackground()
    }
}

// Helper view for statistics boxes
private struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

struct DetailedStatsCard: View {
    let gameStats: GameStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Detailed Statistics")
                .font(.headline)
                .foregroundColor(.white)
            
            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 10) {
                StatRow(title: "Total Games", value: "\(gameStats.totalGamesPlayed)")
                StatRow(title: "Average Accuracy", value: String(format: "%.1f%%", gameStats.averageAccuracy * 100))
                StatRow(title: "Challenges Won", value: "\(gameStats.challengesWon)")
                StatRow(title: "Daily Challenges", value: "\(gameStats.dailyChallengesCompleted)")
                StatRow(title: "Time Attack Best", value: "\(gameStats.timeAttackHighScore)")
                if gameStats.iqTestsCompleted > 0 {
                    StatRow(title: "IQ Test Average", value: String(format: "%.1f", gameStats.iqTestAverage))
                }
            }
        }
        .padding()
        .glassBackground()
    }
}

struct RecentGamesCard: View {
    let scores: [PlayerScore]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Games")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(scores.prefix(5)) { score in
                HStack {
                    Text(score.category.rawValue)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(score.score)")
                        .foregroundColor(Color(hex: "00E5FF"))
                    Text(score.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .glassBackground()
    }
}

// MARK: - Supporting Models

struct PerformanceData: Identifiable {
    let id = UUID()
    let date: Date
    let score: Int
}

struct CategoryPerformance: Identifiable {
    let id = UUID()
    let category: String
    let accuracy: Double
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        GridRow {
            Text(title)
                .foregroundColor(.gray)
            Text(value)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Helper Functions

func generatePerformanceData() -> [PerformanceData] {
    let calendar = Calendar.current
    let today = Date()
    
    return (0..<7).map { daysAgo in
        let date = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
        return PerformanceData(date: date, score: Int.random(in: 50...100))
    }.reversed()
}

func generateCategoryData() -> [CategoryPerformance] {
    [
        CategoryPerformance(category: "Science", accuracy: 0.85),
        CategoryPerformance(category: "History", accuracy: 0.72),
        CategoryPerformance(category: "Geography", accuracy: 0.68),
        CategoryPerformance(category: "Sports", accuracy: 0.91),
        CategoryPerformance(category: "Entertainment", accuracy: 0.78)
    ]
} 