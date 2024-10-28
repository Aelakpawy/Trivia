import SwiftUI

private struct GameGuide: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let sections: [String]
}

struct HelpSupportView: View {
    @State private var selectedGuide: GameGuide?
    @State private var showingGuideDetail = false
    
    private let guides = [
        GameGuide(
            title: "Getting Started",
            icon: "star.fill",
            sections: [
                "Choose a category that interests you",
                "Select a comfortable time limit",
                "Read questions carefully",
                "Use process of elimination for tough questions"
            ]
        ),
        GameGuide(
            title: "Scoring System",
            icon: "trophy.fill",
            sections: [
                "Base points: 10 points per correct answer",
                "Time bonus: Up to 5 extra points for quick answers",
                "Category bonus: 50% extra points for specialized categories",
                "Streak bonus: Extra points for consecutive correct answers"
            ]
        ),
        GameGuide(
            title: "Leveling Up",
            icon: "arrow.up.circle.fill",
            sections: [
                "Gain experience points from each game",
                "Higher difficulties give more points",
                "Complete achievements for bonus points",
                "Maintain streaks for faster progression"
            ]
        ),
        GameGuide(
            title: "Pro Tips",
            icon: "lightbulb.fill",
            sections: [
                "Practice different categories to find your strengths",
                "Start with shorter time limits to improve speed",
                "Use the 50/50 method when unsure",
                "Learn from incorrect answers to improve"
            ]
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
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Game Guides")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        ForEach(guides) { guide in
                            NavigationLink {
                                GuideDetailView(guide: guide)
                            } label: {
                                HStack(spacing: 16) {
                                    Image(systemName: guide.icon)
                                        .font(.title2)
                                        .foregroundColor(Color(hex: "00E5FF"))
                                        .frame(width: 30)
                                    
                                    Text(guide.title)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Support")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        VStack(spacing: 1) {
                            Link(destination: URL(string: "mailto:support@triviaapp.com")!) {
                                HStack {
                                    Image(systemName: "envelope.fill")
                                    Text("Contact Support")
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                }
                                .foregroundColor(.white)
                                .padding()
                            }
                            
                            Link(destination: URL(string: "https://twitter.com/triviaapp")!) {
                                HStack {
                                    Image(systemName: "bubble.left.fill")
                                    Text("Follow us on Twitter")
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                }
                                .foregroundColor(.white)
                                .padding()
                            }
                        }
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct GuideDetailView: View {
    let guide: GameGuide
    
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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(guide.sections, id: \.self) { section in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(hex: "00E5FF"))
                            
                            Text(section)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(guide.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        HelpSupportView()
    }
}
