import SwiftUI

struct IQTestDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header Section
                VStack(spacing: 10) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 60))
                        .foregroundColor(Color(hex: "00E5FF"))
                    
                    Text("IQ Test Performance")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                .padding()
                
                // Score Overview Card
                VStack(spacing: 15) {
                    HStack {
                        Text("Highest Score")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("125")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color(hex: "00E5FF"))
                    }
                    
                    Divider()
                        .background(Color.gray.opacity(0.3))
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Average Score")
                                .foregroundColor(.gray)
                            Text("120")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Tests Taken")
                                .foregroundColor(.gray)
                            Text("3")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(hex: "2E1C4A").opacity(0.6))
                )
                .padding(.horizontal)
                
                // Performance Graph
                VStack(alignment: .leading, spacing: 10) {
                    Text("Score History")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    // Placeholder for graph - replace with actual graph implementation
                    GraphPlaceholder()
                }
                
                // Category Breakdown
                VStack(alignment: .leading, spacing: 10) {
                    Text("Category Performance")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        CategoryRow(category: "Pattern Recognition", score: 85)
                        CategoryRow(category: "Logical Reasoning", score: 90)
                        CategoryRow(category: "Mathematical Ability", score: 80)
                        CategoryRow(category: "Spatial Awareness", score: 88)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(hex: "2E1C4A").opacity(0.6))
                    )
                    .padding(.horizontal)
                }
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "2E1C4A"),
                    Color(hex: "0F1C4D")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GraphPlaceholder: View {
    var body: some View {
        // Custom graph implementation
        VStack {
            HStack(alignment: .bottom, spacing: 20) {
                ForEach(sampleData) { item in
                    VStack {
                        Text("\(item.score)")
                            .font(.caption)
                            .foregroundColor(Color(hex: "00E5FF"))
                        
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(hex: "00E5FF"))
                            .frame(width: 30, height: CGFloat(item.score))
                        
                        Text("Test \(item.test)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(height: 200)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(hex: "2E1C4A").opacity(0.6))
        )
        .padding(.horizontal)
    }
}

struct CategoryRow: View {
    let category: String
    let score: Int
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(category)
                    .foregroundColor(.white)
                Spacer()
                Text("\(score)%")
                    .foregroundColor(Color(hex: "00E5FF"))
            }
            
            ProgressView(value: Double(score), total: 100)
                .tint(Color(hex: "00E5FF"))
        }
    }
}

// Sample data for the graph
struct ScoreData: Identifiable {
    let id = UUID()
    let test: Int
    let score: Int
}

let sampleData = [
    ScoreData(test: 1, score: 115),
    ScoreData(test: 2, score: 120),
    ScoreData(test: 3, score: 125)
]

#Preview {
    NavigationView {
        IQTestDetailsView()
    }
} 