import SwiftUI

struct LeaderboardView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var timeFrame: TimeFrame = .weekly
    @State private var scores: [PlayerScore] = []
    @StateObject private var game = GameLogic()
    
    enum TimeFrame: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case allTime = "All Time"
    }
    
    var filteredScores: [PlayerScore] {
        let calendar = Calendar.current
        let now = Date()
        
        return scores.filter { score in
            switch timeFrame {
            case .daily:
                return calendar.isDateInToday(score.date)
            case .weekly:
                let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
                return score.date >= weekAgo
            case .allTime:
                return true
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "2E1C4A"),
                        Color(hex: "0F1C4D")
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Picker("Time Frame", selection: $timeFrame) {
                        ForEach(TimeFrame.allCases, id: \.self) { frame in
                            Text(frame.rawValue).tag(frame)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    ScrollView {
                        if filteredScores.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(Color(hex: "00E5FF"))
                                    .padding()
                                
                                Text("No Scores Yet")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                
                                Text("Complete a game to see your score here!")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 50)
                        } else {
                            VStack(spacing: 10) {
                                ForEach(Array(filteredScores.enumerated()), id: \.1.id) { index, score in
                                    LeaderboardRow(rank: index + 1, score: score)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Leaderboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "00E5FF"))
                }
            }
        }
        .onAppear {
            scores = game.getStoredScores()
        }
    }
}

struct LeaderboardRow: View {
    let rank: Int
    let score: PlayerScore
    
    var body: some View {
        HStack {
            Text("#\(rank)")
                .font(.headline)
                .foregroundColor(rank <= 3 ? Color(hex: "00E5FF") : .gray)
                .frame(width: 40)
            
            Image(systemName: "person.circle.fill")
                .font(.title2)
                .foregroundColor(Color(hex: "00E5FF"))
            
            VStack(alignment: .leading) {
                Text(score.username)
                    .foregroundColor(.white)
                Text(score.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("\(score.score)")
                .font(.headline)
                .foregroundColor(Color(hex: "00E5FF"))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.1))
        )
        .cornerRadius(10)
    }
}
