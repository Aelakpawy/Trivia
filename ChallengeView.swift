import SwiftUI

struct ChallengeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var challengeManager = ChallengeManager.shared
    @State private var challengeeUsername = ""
    @State private var showingUserSearch = false
    @State private var showingShareSheet = false
    @State private var challengeLink: URL?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @StateObject private var premiumManager = PremiumManager.shared
    @State private var showingPremiumStore = false
    
    var body: some View {
        Group {
            if !premiumManager.isPremiumFeatureAvailable() {
                // Show premium store directly
                PremiumStoreView()
            } else {
                // Original Challenge View content
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
                    
                    VStack(spacing: 0) {
                        // Custom Navigation Bar
                        VStack(spacing: 0) {
                            HStack {
                                Button(action: {
                                    HapticManager.shared.light()
                                    dismiss()
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "chevron.left")
                                        Text("Back")
                                    }
                                    .foregroundColor(Color(hex: "00E5FF"))
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    showAlert = true
                                    alertMessage = "Challenge your friends to a quiz battle! Enter their username or share a quick challenge link to get started."
                                }) {
                                    Image(systemName: "questionmark.circle")
                                        .foregroundColor(Color(hex: "00E5FF"))
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                            
                            HStack {
                                Text("Challenge Mode")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.white)
                                
                                PremiumBadge()
                            }
                            .padding(.top, 12)
                            .padding(.bottom, 16)
                        }
                        .background(Color(hex: "2E1C4A"))
                        .safeAreaInset(edge: .top) { Color.clear.frame(height: 0) }
                        
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 25) {
                                // Challenge Creation Section
                                VStack(alignment: .leading, spacing: 15) {
                                    HStack {
                                        Image(systemName: "person.2.fill")
                                            .foregroundColor(Color(hex: "00E5FF"))
                                            .font(.title2)
                                            .symbolEffect(.bounce, value: showToast)
                                        Text("Challenge a Friend")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 8)
                                    
                                    VStack(spacing: 20) {
                                        // Username Input Section
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Enter username or share a challenge link")
                                                .foregroundColor(.gray)
                                                .font(.subheadline)
                                            
                                            HStack(spacing: 15) {
                                                TextField("Enter username", text: $challengeeUsername)
                                                    .textFieldStyle(TriviaTextFieldStyle())
                                                    .submitLabel(.done)
                                                    .onSubmit {
                                                        createChallenge()
                                                    }
                                                    .autocapitalization(.none)
                                                    .textInputAutocapitalization(.never)
                                                    .overlay(
                                                        HStack {
                                                            Spacer()
                                                            if !challengeeUsername.isEmpty {
                                                                Button(action: {
                                                                    challengeeUsername = ""
                                                                }) {
                                                                    Image(systemName: "xmark.circle.fill")
                                                                        .foregroundColor(.gray)
                                                                        .padding(.trailing, 8)
                                                                }
                                                            }
                                                        }
                                                    )
                                                
                                                Button(action: {
                                                    if !premiumManager.isPremiumFeatureAvailable() {
                                                        showingPremiumStore = true
                                                        return
                                                    }
                                                    createChallenge()
                                                }) {
                                                    HStack {
                                                        if isLoading {
                                                            LoadingView(color: .black, size: 20)
                                                        } else {
                                                            Text("Challenge")
                                                                .fontWeight(.semibold)
                                                        }
                                                    }
                                                    .frame(width: 100)
                                                }
                                                .buttonStyle(PrimaryChallengeButton(isDisabled: challengeeUsername.isEmpty))
                                                .disabled(challengeeUsername.isEmpty || isLoading)
                                            }
                                        }
                                        
                                        // Divider with "OR"
                                        HStack {
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundColor(.gray.opacity(0.3))
                                            
                                            Text("OR")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .padding(.horizontal, 8)
                                            
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundColor(.gray.opacity(0.3))
                                        }
                                        
                                        // Quick Challenge Link Button
                                        Button(action: createQuickChallenge) {
                                            HStack {
                                                Image(systemName: "link")
                                                    .font(.system(size: 16))
                                                    .symbolEffect(.bounce, value: isLoading)
                                                Text("Generate Quick Challenge Link")
                                                    .font(.system(size: 16))
                                            }
                                        }
                                        .buttonStyle(SecondaryChallengeButton())
                                        .disabled(isLoading)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.white.opacity(0.05))
                                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                    )
                                }
                                .padding(.top, 12)
                                
                                // Challenge Sections with improved spacing
                                VStack(spacing: 25) {
                                    ChallengeSection(
                                        title: "Active Challenges",
                                        icon: "flame.fill",
                                        iconColor: Color(hex: "FF6B6B"),
                                        challenges: challengeManager.activeChallenges,
                                        emptyIcon: "gamecontroller.fill",
                                        emptyMessage: "No active challenges",
                                        emptyDescription: "Challenge your friends to start playing!"
                                    )
                                    .padding(.horizontal, 4)
                                    
                                    ChallengeSection(
                                        title: "Pending Challenges",
                                        icon: "clock.fill",
                                        iconColor: Color(hex: "FFB86C"),
                                        challenges: challengeManager.pendingChallenges,
                                        emptyIcon: "envelope.fill",
                                        emptyMessage: "No pending challenges",
                                        emptyDescription: "You'll see challenges from others here"
                                    )
                                    .padding(.horizontal, 4)
                                }
                            }
                            .padding(.bottom, 30)
                        }
                    }
                }
                .alert("Challenge Mode", isPresented: $showAlert) {
                    Button("Got it!", role: .cancel) { }
                } message: {
                    Text(alertMessage)
                }
                .sheet(isPresented: $showingShareSheet) {
                    if let url = challengeLink {
                        ShareSheet(text: """
                            🎮 Join me for a Trivia Challenge!
                            Click here to play: \(url.absoluteString)
                            
                            Can you beat my score? Let's find out! 🏆
                            """)
                    }
                }
                .overlay(alignment: .top) {
                    if showToast {
                        ToastView(message: toastMessage)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
            }
        }
    }
    
    // MARK: - Methods
    
    private func createChallenge() {
        guard !challengeeUsername.isEmpty else { return }
        
        withAnimation(.spring(dampingFraction: 0.7)) {
            isLoading = true
        }
        
        HapticManager.shared.medium()
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let challenge = challengeManager.createChallenge(challengeeUsername: challengeeUsername) {
                challengeLink = challengeManager.generateChallengeLink(for: challenge)
                showingShareSheet = true
                HapticManager.shared.success()
                showToast(message: "Challenge created successfully! 🎮")
                challengeeUsername = "" // Clear the input
            } else {
                alertMessage = "Couldn't create challenge. Please try again."
                showAlert = true
                HapticManager.shared.error()
            }
            
            withAnimation(.spring(dampingFraction: 0.7)) {
                isLoading = false
            }
        }
    }
    
    private func createQuickChallenge() {
        HapticManager.shared.medium()
        withAnimation {
            isLoading = true
        }
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let challenge = challengeManager.createQuickChallenge() {
                challengeLink = challengeManager.generateChallengeLink(for: challenge)
                showingShareSheet = true
                HapticManager.shared.success()
                showToast(message: "Quick challenge created! 🎯")
            }
            withAnimation {
                isLoading = false
            }
        }
    }
    
    private func showToast(message: String) {
        toastMessage = message
        withAnimation {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showToast = false
            }
        }
    }
}

// MARK: - Supporting Views
struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(Color(hex: "00E5FF"))
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
            )
            .padding(.top, 60)
    }
}

#Preview {
    ChallengeView()
} 