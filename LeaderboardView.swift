import SwiftUI
import FirebaseAuth

struct LeaderboardView: View {
    @StateObject private var leaderboardManager = LeaderboardManager.shared
    @State private var selectedTimeFrame: TimeFrame = .allTime
    @State private var isRefreshing = false
    
    enum TimeFrame: String, CaseIterable {
        case today = "Today"
        case week = "This Week"
        case month = "This Month"
        case allTime = "All Time"
    }
    
    var body: some View {
        ZStack {
            // Background
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
                // Time Frame Picker
                Picker("Time Frame", selection: $selectedTimeFrame) {
                    ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                        Text(timeFrame.rawValue)
                            .tag(timeFrame)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top)
                
                if leaderboardManager.isLoading && leaderboardManager.topPlayers.isEmpty {
                    Spacer()
                    LoadingView()
                    Spacer()
                } else if !leaderboardManager.isLoading && leaderboardManager.topPlayers.isEmpty {
                    Spacer()
                    EmptyStateView(
                        icon: "trophy.fill",
                        message: "No Scores Yet",
                        description: "Be the first to set a high score!"
                    )
                    Spacer()
                } else {
                    // Leaderboard List with Pull to Refresh
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(Array(leaderboardManager.topPlayers.enumerated()), id: \.element.id) { index, player in
                                LeaderboardRow(
                                    rank: index + 1,
                                    entry: player,
                                    isCurrentUser: player.id == Auth.auth().currentUser?.uid
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .refreshable {
                        isRefreshing = true
                        await leaderboardManager.fetchLeaderboard()
                        isRefreshing = false
                        HapticManager.shared.success() // Add haptic feedback
                    }
                    
                    // User's Current Rank
                    if leaderboardManager.userRank > 0 {
                        HStack {
                            Text("Your Rank: ")
                                .foregroundColor(.gray)
                            Text("#\(leaderboardManager.userRank)")
                                .foregroundColor(Color(hex: "00E5FF"))
                                .bold()
                        }
                        .font(.headline)
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(10)
                        .padding(.bottom)
                    }
                }
            }
            
            if isRefreshing {
                LoadingView()
            }
        }
        .onAppear {
            Task {
                await leaderboardManager.fetchLeaderboard()
            }
        }
        .onChange(of: selectedTimeFrame) { oldValue, newValue in
            Task {
                await leaderboardManager.fetchLeaderboard()
            }
        }
        .navigationTitle("Leaderboard")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LeaderboardRow: View {
    let rank: Int
    let entry: LeaderboardManager.LeaderboardEntry
    let isCurrentUser: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            // Rank
            Text("#\(rank)")
                .font(.headline)
                .foregroundColor(getRankColor(rank))
                .frame(width: 40)
            
            // Username and Level
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.username)
                    .font(.headline)
                Text(entry.level)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Score and Stats
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(entry.score)")
                    .font(.headline)
                    .foregroundColor(Color(hex: "00E5FF"))
                
                Text("Games: \(entry.gamesPlayed) • \(Int(entry.accuracy))% Acc.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isCurrentUser ? Color(hex: "00E5FF").opacity(0.1) : Color.white.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isCurrentUser ? Color(hex: "00E5FF") : Color.clear,
                    lineWidth: 1
                )
        )
    }
    
    private func getRankColor(_ rank: Int) -> Color {
        switch rank {
        case 1: return Color(hex: "FFD700") // Gold
        case 2: return Color(hex: "C0C0C0") // Silver
        case 3: return Color(hex: "CD7F32") // Bronze
        default: return .white
        }
    }
}
