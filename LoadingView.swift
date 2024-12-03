import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    let color: Color
    let size: CGFloat
    
    init(color: Color = Color(hex: "00E5FF"), size: CGFloat = 40) {
        self.color = color
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 4)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(color, lineWidth: 4)
                .frame(width: size, height: size)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
        }
    }
}

// Loading overlay for full screen loading
struct LoadingOverlay: View {
    let message: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                LoadingView(size: 50)
                Text(message)
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .padding(30)
            .background(Color(hex: "2E1C4A"))
            .cornerRadius(20)
        }
    }
}

#Preview {
    VStack(spacing: 50) {
        LoadingView()
        LoadingOverlay(message: "Loading...")
    }
    .preferredColorScheme(.dark)
} 