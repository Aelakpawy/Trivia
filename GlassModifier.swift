import SwiftUI

struct GlassModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Color.white.opacity(0.1)
                    .blur(radius: 10)
            )
            .background(
                Color.white.opacity(0.05)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.5),
                                .clear,
                                .white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

extension View {
    func glassBackground() -> some View {
        self.modifier(GlassModifier())
    }
} 