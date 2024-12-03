import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var username = ""
    @State private var showUsernameAlert = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("username") private var storedUsername = ""
    @Environment(\.dismiss) private var dismiss
    let isPreview: Bool
    
    init(isPreview: Bool = false) {
        self.isPreview = isPreview
    }
    
    private let pages = [
        OnboardingPage(
            image: "brain.head.profile",
            title: "Welcome to Triviaholic",
            description: "Test your knowledge with thousands of questions across different categories",
            color: Color(hex: "00E5FF")
        ),
        OnboardingPage(
            image: "star.circle.fill",
            title: "Multiple Game Modes",
            description: "Choose from Classic Mode, Weekly Challenges, Time Attack, or challenge your friends!",
            color: Color(hex: "FF9F1C")
        ),
        OnboardingPage(
            image: "trophy.fill",
            title: "Level Up & Earn Rewards",
            description: "Progress through different levels, unlock achievements, and compete on the global leaderboard",
            color: Color(hex: "4CAF50")
        ),
        OnboardingPage(
            image: "person.2.fill",
            title: "Challenge Friends",
            description: "Create custom challenges and compete with friends to see who knows more",
            color: Color(hex: "9B5DE5")
        )
    ]
    
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
            
            VStack(spacing: 0) {
                if currentPage == pages.count {
                    // Username Setup View
                    VStack(spacing: 30) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 100))
                            .foregroundColor(Color(hex: "00E5FF"))
                            .padding()
                        
                        Text("Choose Your Username")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("This will be displayed on the leaderboard")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        TextField("Enter username", text: $username)
                            .textFieldStyle(TriviaTextFieldStyle())
                            .padding(.horizontal, 40)
                            .autocapitalization(.none)
                        
                        Button(isPreview ? "Done" : "Start Playing") {
                            if isPreview {
                                hasCompletedOnboarding = true
                                dismiss()
                            } else {
                                if username.isEmpty {
                                    showUsernameAlert = true
                                } else {
                                    storedUsername = username
                                    hasCompletedOnboarding = true
                                    HapticManager.shared.success()
                                }
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "00E5FF"))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                    }
                    .transition(.opacity)
                } else {
                    // Onboarding Pages
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageView(page: pages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    
                    // Next Button
                    Button(currentPage == pages.count - 1 ? "Set Up Profile" : "Next") {
                        withAnimation {
                            currentPage += 1
                            HapticManager.shared.light()
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "00E5FF"))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .alert("Username Required", isPresented: $showUsernameAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please enter a username to continue")
        }
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: page.image)
                .font(.system(size: 100))
                .foregroundColor(page.color)
                .padding()
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            Text(page.title)
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 32)
        }
        .padding()
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    OnboardingView(isPreview: true)
}
