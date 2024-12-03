import SwiftUI
import FirebaseCore

@main
struct TriviaApp: App {
    @StateObject private var legalManager = LegalManager.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    init() {
        FirebaseManager.shared.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if legalManager.needsToAcceptTerms() {
                LegalTermsView {
                    print("Terms accepted")
                }
            } else if !hasCompletedOnboarding {
                OnboardingView()
                    .preferredColorScheme(.dark)
            } else if !isLoggedIn {
                LoginView()
                    .preferredColorScheme(.dark)
            } else {
                TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    
                    GameModeView()
                        .tabItem {
                            Image(systemName: "gamecontroller.fill")
                            Text("Play")
                        }
                    
                    LeaderboardView()
                        .tabItem {
                            Image(systemName: "trophy.fill")
                            Text("Leaderboard")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }
                .preferredColorScheme(.dark)
            }
        }
    }
}
