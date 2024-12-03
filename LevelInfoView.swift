import SwiftUI

struct LevelInfoView: View {
    let level: Level
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "2E1C4A"),
                    Color(hex: "0F1C4D")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Custom navigation bar
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(Color(hex: "00E5FF"))
                    }
                    Spacer()
                }
                .padding()
                
                // Content
                VStack(spacing: 20) {
                    Image(systemName: level.image)
                        .font(.system(size: 60))
                        .foregroundColor(Color(hex: "00E5FF"))
                    
                    Text(level.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        InfoRow(title: "Required Score", value: "\(level.minScore) points")
                        InfoRow(title: "Max Score", value: "\(level.maxScore) points")
                        InfoRow(title: "Perks", value: "Special achievements and badges")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(hex: "2E1C4A").opacity(0.6))
                    )
                    
                    Spacer()
                }
                .padding()
            }
        }
        .preferredColorScheme(.dark)
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                    }
                }
        )
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
    }
} 