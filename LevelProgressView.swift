import SwiftUI

struct LevelProgressView: View {
    @StateObject private var levelManager = LevelManager.shared
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: levelManager.getCurrentLevel().image)
                    .font(.title2)
                Text(levelManager.getCurrentLevel().name)
                    .font(.headline)
                Spacer()
                Text("Total Score: \(levelManager.currentTotalScore)")
                    .font(.subheadline)
            }
            .foregroundColor(.white)
            
            if let nextLevel = levelManager.getNextLevel() {
                ProgressView(value: levelManager.getProgressToNextLevel()) {
                    HStack {
                        Text("Next: \(nextLevel.name)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(nextLevel.minScore - levelManager.currentTotalScore) points to go")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .tint(Color(hex: "00E5FF"))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(hex: "2E1C4A").opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(hex: "00E5FF").opacity(0.3), lineWidth: 1)
        )
    }
}
