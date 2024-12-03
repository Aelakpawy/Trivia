import SwiftUI

// Shared models for statistics and achievements
struct Statistic: Identifiable {
    let id = UUID()
    let title: String
    let value: String
}

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let isAchieved: Bool
    let image: String
}

// Supporting Views
struct StatisticCard: View {
    let statistic: Statistic
    
    var body: some View {
        VStack(spacing: 10) {
            Text(statistic.value)
                .font(.title2)
                .bold()
                .foregroundColor(Color(hex: "00E5FF"))
            
            Text(statistic.title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .glassBackground()
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    
    var body: some View {
        HStack {
            Image(systemName: achievement.image)
                .font(.title2)
                .foregroundColor(achievement.isAchieved ? Color(hex: "00E5FF") : .gray)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.subheadline)
                    .foregroundColor(achievement.isAchieved ? .white : .gray)
                
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if achievement.isAchieved {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(hex: "00E5FF"))
            }
        }
        .padding()
        .glassBackground()
        .padding(.horizontal)
    }
} 