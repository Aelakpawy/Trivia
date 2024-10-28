import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("username") private var username = ""
    @AppStorage("difficultyLevel") private var difficultyLevel = "Normal"
    @AppStorage("questionTimeLimit") private var questionTimeLimit = 15
    @StateObject private var audioManager = AudioManager.shared
    @State private var showResetAlert = false
    @State private var showUsernameChangeSheet = false
    
    let difficultyLevels = ["Easy", "Normal", "Hard"]
    let timeLimits = [10, 15, 20, 30]
    
    var body: some View {
        BackgroundView {
            ScrollView {
                VStack(spacing: 24) {
                    ProfileSectionView(
                        username: username,
                        showUsernameChangeSheet: $showUsernameChangeSheet
                    )
                    
                    GameSettingsSectionView(
                        difficultyLevel: $difficultyLevel,
                        questionTimeLimit: $questionTimeLimit,
                        difficultyLevels: difficultyLevels,
                        timeLimits: timeLimits
                    )
                    
                    AudioSettingsSectionView(audioManager: audioManager)
                    
                    DataManagementSectionView(showResetAlert: $showResetAlert)
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Reset Progress", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetProgress()
            }
        } message: {
            Text("This will reset all your progress, including scores, achievements, and level. This action cannot be undone.")
        }
        .sheet(isPresented: $showUsernameChangeSheet) {
            UsernameChangeView(username: username)
        }
    }
    
    private func resetProgress() {
        UserDefaults.standard.set(0, forKey: "totalScore")
        UserDefaults.standard.set(0, forKey: "highScore")
        UserDefaults.standard.removeObject(forKey: "playerScores")
        difficultyLevel = "Normal"
        questionTimeLimit = 15
    }
}

// Background View Component
struct BackgroundView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
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
            
            content
        }
    }
}

// Profile Section Component
struct ProfileSectionView: View {
    let username: String
    @Binding var showUsernameChangeSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            SectionHeader(title: "Profile")
            
            Button(action: { showUsernameChangeSheet = true }) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Username")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(username)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Image(systemName: "pencil")
                        .foregroundColor(Color(hex: "00E5FF"))
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
}

// Game Settings Section Component
struct GameSettingsSectionView: View {
    @Binding var difficultyLevel: String
    @Binding var questionTimeLimit: Int
    let difficultyLevels: [String]
    let timeLimits: [Int]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            SectionHeader(title: "Game Settings")
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Difficulty Level")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Picker("Difficulty", selection: $difficultyLevel) {
                        ForEach(difficultyLevels, id: \.self) { level in
                            Text(level).tag(level)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Default Question Time")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Picker("Time Limit", selection: $questionTimeLimit) {
                        ForEach(timeLimits, id: \.self) { time in
                            Text("\(time)s").tag(time)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

// Audio Settings Section Component
struct AudioSettingsSectionView: View {
    @ObservedObject var audioManager: AudioManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            SectionHeader(title: "Audio")
            
            VStack(spacing: 1) {
                Toggle("Background Music", isOn: .init(
                    get: { audioManager.isMusicEnabled },
                    set: { _ in audioManager.toggleMusic() }
                ))
                .padding()
                .tint(Color(hex: "00E5FF"))
                
                Toggle("Sound Effects", isOn: .init(
                    get: { audioManager.isSoundEnabled },
                    set: { _ in audioManager.toggleSound() }
                ))
                .padding()
                .tint(Color(hex: "00E5FF"))
            }
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            .foregroundColor(.white)
        }
        .padding(.horizontal)
    }
}

// Data Management Section Component
struct DataManagementSectionView: View {
    @Binding var showResetAlert: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            SectionHeader(title: "Data Management")
            
            Button(action: { showResetAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                    Text("Reset Game Progress")
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
}

// Section Header Component
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.gray)
            .padding(.horizontal)
            .padding(.bottom, 8)
    }
}

// Username Change View
struct UsernameChangeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var newUsername: String
    @AppStorage("username") private var storedUsername = ""
    
    init(username: String) {
        _newUsername = State(initialValue: username)
    }
    
    var body: some View {
        NavigationView {
            BackgroundView {
                VStack(spacing: 20) {
                    TextField("Enter new username", text: $newUsername)
                        .textFieldStyle(TriviaTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button("Save") {
                        if !newUsername.isEmpty {
                            storedUsername = newUsername
                            dismiss()
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "00E5FF"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("Change Username")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
