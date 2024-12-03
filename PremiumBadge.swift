import SwiftUI

struct PremiumBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "crown.fill")
                .foregroundColor(Color(hex: "FFD700"))
            Text("PRO")
                .font(.caption2)
                .bold()
                .foregroundColor(Color(hex: "FFD700"))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "FFD700").opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "FFD700").opacity(0.5), lineWidth: 1)
                )
        )
    }
} 