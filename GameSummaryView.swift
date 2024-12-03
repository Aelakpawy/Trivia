import SwiftUI

struct GameSummaryView: View {
    let questions: [Question]
    let userAnswers: [Int]
    let score: Int
    let totalQuestions: Int
    let gameMode: GameMode
    @Environment(\.dismiss) var dismiss
    
    private var accuracy: Double {
        let correctAnswers = zip(questions, userAnswers)
            .filter { $0.0.correctAnswer == $0.1 }
            .count
        return Double(correctAnswers) / Double(totalQuestions) * 100
    }
    
    private var scoreDisplay: String {
        if gameMode == .iqTest {
            let iqScore = 100 + (score * 3)
            return "\(iqScore)"
        } else {
            return "\(score)/\(totalQuestions)"
        }
    }
    
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
                // Header
                VStack(spacing: 10) {
                    Text("Game Summary")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                    HStack(spacing: 20) {
                        if gameMode == .iqTest {
                            SummaryStatView(
                                title: "IQ Score",
                                value: scoreDisplay,
                                icon: "brain.head.profile",
                                color: Color(hex: "00E5FF")
                            )
                        } else {
                            SummaryStatView(
                                title: "Score",
                                value: scoreDisplay,
                                icon: "star.fill",
                                color: Color(hex: "00E5FF")
                            )
                        }
                        
                        SummaryStatView(
                            title: "Accuracy",
                            value: String(format: "%.0f%%", accuracy),
                            icon: "percent",
                            color: Color(hex: "4CAF50")
                        )
                    }
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Questions List
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(Array(zip(questions.indices, questions)), id: \.0) { index, question in
                            QuestionSummaryCard(
                                question: question,
                                userAnswer: index < userAnswers.count ? userAnswers[index] : 0,
                                questionNumber: index + 1
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Done Button
                Button(action: { dismiss() }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "00E5FF"))
                        .cornerRadius(12)
                }
                .padding()
            }
            .padding(.vertical)
        }
    }
}

struct SummaryStatView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                Text(value)
            }
            .font(.title3)
            .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct QuestionSummaryCard: View {
    let question: Question
    let userAnswer: Int
    let questionNumber: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Question Number and Text
            HStack(alignment: .top) {
                Text("Q\(questionNumber)")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "00E5FF").opacity(0.2))
                    .foregroundColor(Color(hex: "00E5FF"))
                    .cornerRadius(8)
                
                Text(question.text)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            // Answers
            VStack(spacing: 8) {
                ForEach(0..<question.answers.count, id: \.self) { index in
                    HStack {
                        Text(question.answers[index])
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Show indicators for correct/wrong answers
                        if index == question.correctAnswer {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(hex: "4CAF50"))
                        } else if index == userAnswer && index != question.correctAnswer {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color(hex: "FF6B6B"))
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(getAnswerBackgroundColor(index))
                    )
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
    
    private func getAnswerBackgroundColor(_ index: Int) -> Color {
        if index == question.correctAnswer {
            return Color(hex: "4CAF50").opacity(0.1)
        } else if index == userAnswer && index != question.correctAnswer {
            return Color(hex: "FF6B6B").opacity(0.1)
        }
        return Color.white.opacity(0.05)
    }
} 