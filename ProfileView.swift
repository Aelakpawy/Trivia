import SwiftUI
import UIKit
import MessageUI  // For MFMailComposeViewController
import Security   // For SecItemDelete

struct ProfileView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    @AppStorage("username") private var storedUsername = ""
    @StateObject private var levelManager = LevelManager.shared
    @State private var showingLogoutAlert = false
    @State private var showingShareOptions = false
    @State private var shareText = ""
    @StateObject private var premiumManager = PremiumManager.shared
    @State private var showingPremiumStore = false
    @State private var showingEmailShare = false
    @State private var showingRegularShare = false
    
    private let statistics = [
        Statistic(title: "Games Played", value: "127"),
        Statistic(title: "Correct Answers", value: "891"),
        Statistic(title: "Accuracy", value: "76%"),
        Statistic(title: "Best Streak", value: "15")
    ]
    
    private let achievements: [Achievement] = [
        Achievement(
            title: "First Victory",
            description: "Win your first game",
            isAchieved: true,
            image: "star.fill"
        ),
        Achievement(
            title: "Perfect Game",
            description: "Score 100% in a game",
            isAchieved: true,
            image: "crown.fill"
        ),
        Achievement(
            title: "Knowledge Seeker",
            description: "Play 50 games",
            isAchieved: true,
            image: "book.fill"
        ),
        Achievement(
            title: "Trivia Master",
            description: "Reach level Einstein",
            isAchieved: false,
            image: "trophy.fill"
        ),
        Achievement(
            title: "Speed Demon",
            description: "Answer all questions under 30 seconds",
            isAchieved: false,
            image: "bolt.fill"
        ),
        Achievement(
            title: "Social Butterfly",
            description: "Share 10 results",
            isAchieved: false,
            image: "person.2.fill"
        )
    ]
    
    private func shareProfile() {
        let formattedText = """
        TRIVIAHOLIC PROGRESS REPORT 🏆
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━

        👤 PLAYER PROFILE
        ▸ Player: \(storedUsername)
        ▸ Current Level: \(levelManager.getCurrentLevel().name)
        ▸ Total Score: \(levelManager.currentTotalScore)

        📊 PERFORMANCE STATS
        ▸ Games Played: \(statistics[0].value)
        ▸ Correct Answers: \(statistics[1].value)
        ▸ Accuracy Rate: \(statistics[2].value)
        ▸ Best Streak: \(statistics[3].value)

        🏆 ACHIEVEMENTS (\(achievements.filter { $0.isAchieved }.count)/\(achievements.count))
        \(achievements.filter { $0.isAchieved }.map { "✓ " + $0.title }.joined(separator: "\n"))

        ━━━━━━━━━━━━━━━━━━━━━━━━━━━
        📱 Download Triviaholic and challenge me!
        """
        
        shareText = formattedText
        showingShareOptions = true
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
        
        let audioManager = AudioManager.shared
        audioManager.setGameInProgress(false)
        audioManager.toggleMusic()
        audioManager.toggleSound()
        
        levelManager.currentTotalScore = 0
        isLoggedIn = false
    }
    
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
                    
                    // Statistics Section
                    if premiumManager.isPremiumFeatureAvailable() {
                        DetailedStatsView(statistics: statistics)
                        
                        // IQ Test Results Card
                        NavigationLink(destination: IQTestDetailsView()) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: "brain.head.profile")
                                        .foregroundColor(Color(hex: "00E5FF"))
                                    Text("IQ Test Results")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    Spacer()
                                    Text("125") // Replace with actual IQ score
                                        .foregroundColor(Color(hex: "00E5FF"))
                                        .font(.title2)
                                        .bold()
                                }
                                Text("Average: 120 • Tests: 3") // Replace with actual stats
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(hex: "2E1C4A").opacity(0.6))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(hex: "00E5FF").opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal)
                        }
                    } else {
                        VStack(spacing: 30) {
                            // Games Played and Correct Answers
                            HStack(spacing: 20) {
                                StatisticCard(statistic: statistics[0])
                                StatisticCard(statistic: statistics[1])
                            }
                            .padding(.horizontal)
                            
                            // Unlock Detailed Statistics Button
                            Button(action: {
                                showingPremiumStore = true
                            }) {
                                HStack {
                                    Image(systemName: "crown.fill")
                                        .foregroundColor(Color(hex: "FFD700"))
                                    Text("Unlock Detailed Statistics")
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .glassBackground()
                            }
                            .padding(.horizontal)
                        }
                    }
                    
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
                        
                        NavigationLink(destination: StatisticsReportView()) {
                            SettingsButton(title: "Statistics Report", icon: "chart.bar.xaxis")
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
            .actionSheet(isPresented: $showingShareOptions) {
                ActionSheet(
                    title: Text("Share Progress"),
                    message: Text("Choose how you'd like to share"),
                    buttons: [
                        .default(Text("Email")) {
                            showingEmailShare = true
                        },
                        .default(Text("Other")) {
                            showingRegularShare = true
                        },
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $showingEmailShare) {
                ShareSheet(text: shareText)
            }
            .sheet(isPresented: $showingRegularShare) {
                ActivityViewController(activityItems: [shareText])
            }
            .sheet(isPresented: $showingPremiumStore) {
                PremiumStoreView()
            }
            .navigationTitle("Profile")
        }
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
