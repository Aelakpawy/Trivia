import SwiftUI

struct DetailedStatsView: View {
    let statistics: [Statistic]
    @StateObject private var premiumManager = PremiumManager.shared
    
    var body: some View {
        VStack(spacing: 25) {
            // Basic Stats Grid
            HStack(spacing: 20) {
                // Games Played
                VStack(spacing: 8) {
                    Text(statistics[0].value)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color(hex: "00E5FF"))
                    Text("Games Played")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .glassBackground()
                
                // Correct Answers
                VStack(spacing: 8) {
                    Text(statistics[1].value)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color(hex: "00E5FF"))
                    Text("Correct Answers")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .glassBackground()
            }
            .padding(.horizontal)
            
            // Detailed Stats
            VStack(spacing: 20) {
                // Accuracy
                DetailedStatRow(
                    icon: "target",
                    title: "Accuracy",
                    value: statistics[2].value,
                    trend: "+5% this week"
                )
                
                // Best Streak
                DetailedStatRow(
                    icon: "flame.fill",
                    title: "Best Streak",
                    value: statistics[3].value,
                    trend: "Personal Best!"
                )
                
                // Average Time
                DetailedStatRow(
                    icon: "clock.fill",
                    title: "Average Time",
                    value: "8.5s",
                    trend: "-0.5s this week"
                )
                
                // Category Performance
                DetailedStatRow(
                    icon: "chart.bar.fill",
                    title: "Best Category",
                    value: "Science",
                    trend: "85% accuracy"
                )
            }
            .padding(.horizontal)
        }
    }
}

struct DetailedStatRow: View {
    let icon: String
    let title: String
    let value: String
    let trend: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(hex: "00E5FF"))
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                HStack {
                    Text(value)
                        .font(.headline)
                        .foregroundColor(Color(hex: "00E5FF"))
                    
                    Text(trend)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .padding()
        .glassBackground()
    }
}

struct BasicStatsView: View {
    let statistics: [Statistic]
    
    var body: some View {
        VStack(spacing: 30) {
            // Games Played and Correct Answers
            HStack(spacing: 20) {
                StatisticCard(statistic: statistics[0])
                StatisticCard(statistic: statistics[1])
            }
            .padding(.horizontal)
        }
    }
}

struct IQTestStatsView: View {
    @ObservedObject private var iqTestManager = IQTestManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if let latestScore = iqTestManager.latestScore {
                DetailedStatRow(
                    icon: "brain.head.profile",
                    title: "Latest IQ Score",
                    value: "\(latestScore)",
                    trend: getScoreDescription(latestScore)
                )
            }
            
            if !iqTestManager.results.isEmpty {
                let average = iqTestManager.results.map(\.score).reduce(0, +) / iqTestManager.results.count
                
                DetailedStatRow(
                    icon: "chart.bar.fill",
                    title: "Average IQ Score",
                    value: "\(average)",
                    trend: "Based on \(iqTestManager.results.count) tests"
                )
                
                if let highest = iqTestManager.results.map(\.score).max() {
                    DetailedStatRow(
                        icon: "trophy.fill",
                        title: "Highest Score",
                        value: "\(highest)",
                        trend: getScoreDescription(highest)
                    )
                }
            }
        }
        .padding()
        .glassBackground()
    }
    
    private func getScoreDescription(_ score: Int) -> String {
        switch score {
        case 130...200: return "Very Superior"
        case 120...129: return "Superior"
        case 110...119: return "High Average"
        case 90...109: return "Average"
        case 80...89: return "Low Average"
        case 70...79: return "Borderline"
        default: return "Extremely Low"
        }
    }
}

#Preview {
    ZStack {
        Color(hex: "2E1C4A")
            .ignoresSafeArea()
        
        DetailedStatsView(statistics: [
            Statistic(title: "Games Played", value: "127"),
            Statistic(title: "Correct Answers", value: "891"),
            Statistic(title: "Accuracy", value: "76%"),
            Statistic(title: "Best Streak", value: "15")
        ])
    }
    .preferredColorScheme(.dark)
} 