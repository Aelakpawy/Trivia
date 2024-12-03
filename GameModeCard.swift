import SwiftUI

struct GameModeCard: View {
    let mode: GameMode
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: mode.icon)
                .font(.system(size: 32))
                .foregroundColor(isSelected ? mode.color : .white)
                .frame(width: 60)
                .padding(.leading, 10)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(mode.rawValue)
                        .font(.headline)
                        .bold()
                    
                    if mode.requiresPremium {
                        PremiumBadge()
                    }
                }
                
                Text(mode.description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.trailing)
        }
        .foregroundColor(isSelected ? mode.color : .white)
        .frame(maxWidth: .infinity)
        .frame(height: 90)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .background(
                    Color.white.opacity(0.05)
                        .blur(radius: 10)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.5),
                                    .clear,
                                    .white.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(mode.color, lineWidth: isSelected ? 2 : 0)
        )
        .shadow(color: isSelected ? mode.color.opacity(0.3) : .clear, radius: 10)
    }
}

#Preview {
    VStack {
        GameModeCard(mode: .classic, isSelected: true)
        GameModeCard(mode: .weeklyChallenge, isSelected: false)
        GameModeCard(mode: .timeAttack, isSelected: false)
        GameModeCard(mode: .challenge, isSelected: false)
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
} 