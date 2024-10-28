import SwiftUI

struct ProfileView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    @AppStorage("username") private var storedUsername = ""
    @StateObject private var levelManager = LevelManager.shared
    @State private var showingLogoutAlert = false
    @State private var selectedTimeFrame: TimeFrame = .allTime
    @State private var showingShareSheet = false
    @State private var shareText = ""
    
    private func shareProfile() {
        shareText = """
        🎮 My Trivia Master Progress 🏆
        Player: \(storedUsername)
        Level: \(levelManager.getCurrentLevel().name)
        Total Score: \(levelManager.currentTotalScore)
        
        📊 Stats:
        Games Played: \(statistics[0].value)
        Correct Answers: \(statistics[1].value)
        Accuracy: \(statistics[2].value)
        Best Streak: \(statistics[3].value)
        
        🌟 Achievements Unlocked: \(achievements.filter { $0.isAchieved }.count)/\(achievements.count)
        
        Challenge me in Trivia Master!
        """
        showingShareSheet = true
    }
    
    private func handleLogout() {
        if let email = UserDefaults.standard.string(forKey: "userEmail") {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: email
            ]
            SecItemDelete(query as CFDictionary)
        }
        
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key != "hasCompletedOnboarding" {
                defaults.removeObject(forKey: key)
            }
        }
        
        AudioManager.shared.isMusicEnabled = true
        AudioManager.shared.isSoundEnabled = true
        
        levelManager.currentTotalScore = 0
        isLoggedIn = false
    }
    
    enum TimeFrame: String, CaseIterable {
        case week = "This Week"
        case month = "This Month"
        case allTime = "All Time"
    }
    
    let statistics = [
        Statistic(title: "Games Played", value: "127"),
        Statistic(title: "Correct Answers", value: "891"),
        Statistic(title: "Accuracy", value: "76%"),
        Statistic(title: "Best Streak", value: "15")
    ]
    
    let achievements = [
        Achievement(title: "First Victory", description: "Win your first game", isAchieved: true, image: "star.fill"),
        Achievement(title: "Perfect Game", description: "Score 100% in a game", isAchieved: true, image: "crown.fill"),
        Achievement(title: "Knowledge Seeker", description: "Play 50 games", isAchieved: true, image: "book.fill"),
        Achievement(title: "Trivia Master", description: "Reach level Einstein", isAchieved: false, image: "trophy.fill"),
        Achievement(title: "Speed Demon", description: "Answer all questions under 30 seconds", isAchieved: false, image: "bolt.fill"),
        Achievement(title: "Social Butterfly", description: "Share 10 results", isAchieved: false, image: "person.2.fill")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    VStack(spacing: 15) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(Color(hex: "00E5FF"))
                        
                        Text(storedUsername.isEmpty ? "User" : storedUsername)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text(levelManager.getCurrentLevel().name)
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "00E5FF"))
                        
                        // Share Button
                        Button(action: shareProfile) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title3)
                                Text("Share Progress")
                                    .font(.headline)
                            }
                            .foregroundColor(Color(hex: "00E5FF"))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "00E5FF"), lineWidth: 1)
                            )
                        }
                    }
                    .padding()
                    
                    // Statistics Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        ForEach(statistics) { stat in
                            StatisticCard(statistic: stat)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Achievement Section
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Achievements")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(achievements.filter { $0.isAchieved }.count)/\(achievements.count)")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "00E5FF"))
                        }
                        .padding(.horizontal)
                        
                        ForEach(achievements) { achievement in
                            AchievementRow(achievement: achievement)
                        }
                    }
                    .padding(.top)
                    
                    // Settings Buttons
                    VStack(spacing: 15) {
                        NavigationLink(destination: SettingsView()) {
                            SettingsButton(title: "Settings", icon: "gear")
                        }
                        
                        NavigationLink(destination: HelpSupportView()) {
                            SettingsButton(title: "Help & Support", icon: "questionmark.circle")
                        }
                        
                        Button {
                            showingLogoutAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .frame(width: 30)
                                Text("Logout")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .foregroundColor(.red)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: "2E1C4A").opacity(0.6))
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
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
            .alert("Logout", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) {
                    handleLogout()
                }
            } message: {
                Text("Are you sure you want to logout? This will clear all your session data.")
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(text: shareText)
            }
            .navigationTitle("Profile")
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let text: String
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityItems = [text]
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct Statistic: Identifiable {
    let id = UUID()
    let title: String
    let value: String
}

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let isAchieved: Bool
    let image: String
}

struct StatisticCard: View {
    let statistic: Statistic
    
    var body: some View {
        VStack(spacing: 10) {
            Text(statistic.value)
                .font(.title2)
                .bold()
                .foregroundColor(Color(hex: "00E5FF"))
            
            Text(statistic.title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(hex: "2E1C4A").opacity(0.6))
        )
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    
    var body: some View {
        HStack {
            Image(systemName: achievement.image)
                .font(.title2)
                .foregroundColor(achievement.isAchieved ? Color(hex: "00E5FF") : .gray)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.subheadline)
                    .foregroundColor(achievement.isAchieved ? .white : .gray)
                
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if achievement.isAchieved {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(hex: "00E5FF"))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "2E1C4A").opacity(0.6))
        )
        .padding(.horizontal)
    }
}

struct SettingsButton: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .foregroundColor(.white)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "2E1C4A").opacity(0.6))
        )
        .padding(.horizontal)
    }
}
