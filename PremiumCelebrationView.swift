import SwiftUI

struct PremiumCelebrationView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "2E1C4A"),
                    Color(hex: "0F1C4D")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Crown icon
                Image(systemName: "crown.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: "FFD700"))
                    .symbolEffect(.bounce)
                
                Text("Welcome to Premium!")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                Text("You now have access to all premium features")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Feature list
                VStack(alignment: .leading, spacing: 15) {
                    PremiumFeatureRow(icon: "star.fill", text: "Exclusive game modes")
                    PremiumFeatureRow(icon: "clock.fill", text: "Time Attack mode")
                    PremiumFeatureRow(icon: "person.2.fill", text: "Challenge friends")
                    PremiumFeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Detailed statistics")
                }
                .padding()
                
                Button("Start Playing") {
                    dismiss()
                }
                .font(.headline)
                .foregroundColor(.black)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "00E5FF"))
                .cornerRadius(10)
                .padding(.horizontal, 40)
            }
            .padding()
        }
    }
}

struct PremiumFeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "FFD700"))
            Text(text)
                .foregroundColor(.white)
        }
    }
} 