import SwiftUI

struct QuestionView: View {
    let question: Question
    @Binding var selectedAnswer: Int?
    let showingFeedback: Bool
    let onAnswerSelected: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Question text
            Text(question.text)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(hex: "2E1C4A").opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(hex: "00E5FF").opacity(0.3), lineWidth: 1)
                        )
                )
            
            // Answer buttons
            VStack(spacing: 12) {
                ForEach(0..<question.answers.count, id: \.self) { index in
                    AnswerButton(
                        text: question.answers[index],
                        isSelected: selectedAnswer == index,
                        isCorrect: showingFeedback ? (index == question.correctAnswer) : nil,
                        isWrong: showingFeedback ? (selectedAnswer == index && index != question.correctAnswer) : nil
                    ) {
                        if !showingFeedback {
                            onAnswerSelected(index)
                        }
                    }
                }
            }
        }
        .padding()
    }
} 