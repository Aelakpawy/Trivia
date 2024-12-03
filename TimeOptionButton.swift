import SwiftUI

struct TimeOptionButton: View {
    let seconds: Int?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(seconds.map { "\($0)s" } ?? "∞")
                .font(.headline)
                .foregroundColor(isSelected ? .black : .white)
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color(hex: "00E5FF") : Color(hex: "2E1C4A").opacity(0.6))
                )
        }
    }
}

#Preview {
    HStack {
        TimeOptionButton(seconds: 30, isSelected: true) {}
        TimeOptionButton(seconds: 60, isSelected: false) {}
        TimeOptionButton(seconds: nil, isSelected: false) {}
    }
    .padding()
    .background(Color.black)
} 