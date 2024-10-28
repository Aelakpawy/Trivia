import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var username = ""
    @State private var showUsernameAlert = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("username") private var storedUsername = ""
    
    private let pages = [
        OnboardingPage(
            image: "brain.head.profile",
            title: "Welcome to Trivia Master",
            description: "Challenge yourself with exciting questions across various topics"
        ),
        OnboardingPage(
            image: "trophy.fill",
            title: "Earn Achievements",
            description: "Level up and unlock new ranks as you progress"
        ),
        OnboardingPage(
            image: "person.3.fill",
            title: "Compete Globally",
            description: "Join players worldwide and climb the leaderboard"
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
            
            VStack(spacing: 20) {
                if currentPage == pages.count {
                    // Username Input View
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
                        
                        Button("Start Playing") {
                            if username.isEmpty {
                                showUsernameAlert = true
                            } else {
                                storedUsername = username
                                hasCompletedOnboarding = true
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
                } else {
                    // Regular Onboarding Pages
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            VStack(spacing: 20) {
                                Image(systemName: pages[index].image)
                                    .font(.system(size: 100))
                                    .foregroundColor(Color(hex: "00E5FF"))
                                    .padding()
                                
                                Text(pages[index].title)
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.white)
                                
                                Text(pages[index].description)
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    
                    Button(currentPage == pages.count - 1 ? "Set Up Profile" : "Next") {
                        withAnimation {
                            currentPage += 1
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
}
