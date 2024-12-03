import SwiftUI

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool?
    let isWrong: Bool?
    let action: () -> Void
    
    var backgroundColor: Color {
        if let isCorrect = isCorrect {
            return isCorrect ? Color(hex: "4CAF50").opacity(0.3) : Color(hex: "2E1C4A").opacity(0.6)
        } else if let isWrong = isWrong {
            return isWrong ? Color(hex: "FF6B6B").opacity(0.3) : Color(hex: "2E1C4A").opacity(0.6)
        }
        return isSelected ? Color(hex: "00E5FF").opacity(0.3) : Color(hex: "2E1C4A").opacity(0.6)
    }
    
    var borderColor: Color {
        if let isCorrect = isCorrect {
            return isCorrect ? Color(hex: "4CAF50") : Color.clear
        } else if let isWrong = isWrong {
            return isWrong ? Color(hex: "FF6B6B") : Color.clear
        }
        return isSelected ? Color(hex: "00E5FF") : Color(hex: "00E5FF").opacity(0.3)
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 8)
                
                Spacer()
                
                if let isCorrect = isCorrect, isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "4CAF50"))
                        .font(.title2)
                } else if let isWrong = isWrong, isWrong {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(hex: "FF6B6B"))
                        .font(.title2)
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(borderColor, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(Rectangle())
    }
} 