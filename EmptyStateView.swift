import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let message: String
    let description: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text(message)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

#Preview {
    EmptyStateView(
        icon: "gamecontroller.fill",
        message: "No active challenges",
        description: "Challenge your friends to start playing!"
    )
    .preferredColorScheme(.dark)
    .background(Color(hex: "2E1C4A"))
} 