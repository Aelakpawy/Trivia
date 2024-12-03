import SwiftUI

@main
struct TriviaApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
 
    
    var body: some Scene {
        WindowGroup {
            if !hasCompletedOnboarding {
                OnboardingView()
            } else if !isLoggedIn {
                LoginView()
            } else {
                TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    
                    // Replace ContentView with CategorySelectionView
                    CategorySelectionView()
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
            }
        }
    }
}
