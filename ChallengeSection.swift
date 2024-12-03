import SwiftUI

struct ChallengeSection: View {
    let title: String
    let icon: String
    let iconColor: Color
    let challenges: [ChallengeManager.Challenge]
    let emptyIcon: String
    let emptyMessage: String
    let emptyDescription: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Section Header
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.title2)
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            
            // Content
            if challenges.isEmpty {
                EmptyStateView(
                    icon: emptyIcon,
                    message: emptyMessage,
                    description: emptyDescription
                )
                .transition(.opacity)
            } else {
                ForEach(challenges) { challenge in
                    ChallengeRow(challenge: challenge)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
}

#Preview {
    VStack {
        ChallengeSection(
            title: "Active Challenges",
            icon: "flame.fill",
            iconColor: Color(hex: "FF6B6B"),
            challenges: [],
            emptyIcon: "gamecontroller.fill",
            emptyMessage: "No active challenges",
            emptyDescription: "Challenge your friends to start playing!"
        )
        
        ChallengeSection(
            title: "Pending Challenges",
            icon: "clock.fill",
            iconColor: Color(hex: "FFB86C"),
            challenges: [],
            emptyIcon: "envelope.fill",
            emptyMessage: "No pending challenges",
            emptyDescription: "You'll see challenges from others here"
        )
    }
    .padding()
    .background(Color(hex: "2E1C4A"))
    .preferredColorScheme(.dark)
} 