import SwiftUI

struct GameModeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimeLimit: Int? = nil
    @State private var showingGameView = false
    @State private var showingChallengeView = false
    @State private var selectedMode: GameMode?
    @State private var isLoading = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @StateObject private var premiumManager = PremiumManager.shared
    @State private var showingPremiumAlert = false
    @State private var showingPremiumStore = false
    
    // Time options only shown for Time Attack mode
    let timeOptions = [30, 60, 120, nil]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "2E1C4A"),
                    Color(hex: "0F1C4D")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 25) {
                        Text("Welcome to Triviaholic")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.top, 20)
                            .transition(.move(edge: .top))
                        
                        // Game Modes Stack
                        VStack(spacing: 20) {
                            ForEach(GameMode.allCases) { mode in
                                Button(action: { handleModeSelection(mode: mode) }) {
                                    GameModeCard(mode: mode, isSelected: selectedMode == mode)
                                        .onTapGesture {
                                            withAnimation(.spring(response: 0.3)) {
                                                if selectedMode == mode {
                                                    selectedMode = nil // Deselect if tapped again
                                                } else {
                                                    selectedMode = mode
                                                }
                                            }
                                            HapticManager.shared.selection()
                                            
                                            if mode == .challenge {
                                                showingChallengeView = true
                                            }
                                        }
                                        .transition(.scale.combined(with: .opacity))
                                        .shadow(
                                            color: selectedMode == mode ? mode.color.opacity(0.3) : .clear,
                                            radius: 10
                                        )
                                }
                                .alert(isPresented: $showingPremiumAlert) {
                                    premiumManager.showPremiumRequired()
                                }
                                .sheet(isPresented: $showingPremiumStore) {
                                    PremiumStoreView()
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Time Selection for Time Attack mode
                        if selectedMode == .timeAttack {
                            VStack(alignment: .leading, spacing: 20) {
                                // Time Selection Header
                                HStack {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(Color(hex: "00E5FF"))
                                        .font(.title2)
                                    Text("Select Time Limit")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal)
                                
                                // Time Options
                                VStack(spacing: 15) {
                                    HStack(spacing: 15) {
                                        ForEach(timeOptions, id: \.self) { seconds in
                                            Button {
                                                withAnimation(.spring(response: 0.3)) {
                                                    selectedTimeLimit = seconds
                                                }
                                                HapticManager.shared.light()
                                            } label: {
                                                VStack(spacing: 8) {
                                                    Text(seconds.map { "\($0)s" } ?? "∞")
                                                        .font(.title3)
                                                        .bold()
                                                    
                                                    Text(getTimeDescription(seconds))
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                }
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 80)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .fill(selectedTimeLimit == seconds ? 
                                                             Color(hex: "FF6B6B").opacity(0.2) : 
                                                             Color.white.opacity(0.05))
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .stroke(
                                                                    selectedTimeLimit == seconds ?
                                                                    Color(hex: "FF6B6B") : Color.clear,
                                                                    lineWidth: 2
                                                                )
                                                        )
                                                )
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    
                                    if selectedTimeLimit == nil {
                                        Text("Select a time limit to continue")
                                            .font(.subheadline)
                                            .foregroundColor(Color(hex: "FF6B6B"))
                                            .padding(.top, 5)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical, 10)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.vertical)
                }
                
                // Play Button
                VStack {
                    Button(action: startGame) {
                        ZStack {
                            Text("Play")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.black)
                                .opacity(isLoading ? 0 : 1)
                            
                            if isLoading {
                                LoadingView(color: .black, size: 25)
                            }
                        }
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(buttonBackgroundColor)
                        )
                    }
                    .disabled(buttonDisabled)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .overlay(alignment: .top) {
            if showToast {
                ToastView(message: toastMessage)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .fullScreenCover(isPresented: $showingGameView) {
            if let mode = selectedMode {
                GameView(
                    gameMode: mode,
                    timeLimit: mode == .timeAttack ? selectedTimeLimit : nil
                )
            }
        }
        .fullScreenCover(isPresented: $showingChallengeView) {
            ChallengeView()
        }
        .sheet(isPresented: $showingPremiumStore) {
            PremiumStoreView()
        }
        .onReceive(NotificationCenter.default.publisher(for: .showPremiumStore)) { _ in
            showingPremiumStore = true
        }
    }
    
    // MARK: - Computed Properties
    
    private var buttonDisabled: Bool {
        if selectedMode == nil { return true }
        if selectedMode == .timeAttack && selectedTimeLimit == nil { return true }
        return isLoading
    }
    
    private var buttonBackgroundColor: Color {
        if buttonDisabled {
            return Color(hex: "00E5FF").opacity(0.3)
        }
        return selectedMode?.color ?? Color(hex: "00E5FF")
    }
    
    // MARK: - Methods
    
    private func handleModeSelection(mode: GameMode) {
        if mode.requiresPremium && !premiumManager.isPremiumFeatureAvailable() {
            showingPremiumStore = true
            return
        }
        
        withAnimation(.spring(response: 0.3)) {
            if selectedMode == mode {
                selectedMode = nil
            } else {
                selectedMode = mode
            }
        }
        HapticManager.shared.selection()
        
        if mode == .challenge {
            showingChallengeView = true
        }
    }
    
    private func startGame() {
        guard let mode = selectedMode else { return }
        
        // Check premium access again before starting
        if mode.requiresPremium && !premiumManager.isPremiumFeatureAvailable() {
            showingPremiumStore = true
            return
        }
        
        if mode == .timeAttack && selectedTimeLimit == nil {
            showToast(message: "Please select a time limit")
            HapticManager.shared.warning()
            return
        }
        
        HapticManager.shared.heavy()
        withAnimation {
            isLoading = true
        }
        
        // Simulate loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                isLoading = false
                showingGameView = true
            }
        }
    }
    
    private func showToast(message: String) {
        toastMessage = message
        withAnimation {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showToast = false
            }
        }
    }
    
    private func getTimeDescription(_ seconds: Int?) -> String {
        switch seconds {
        case 30:
            return "Quick"
        case 60:
            return "Standard"
        case 120:
            return "Extended"
        case nil:
            return "No Limit"
        default:
            return ""
        }
    }
}

// MARK: - Preview
#Preview {
    GameModeView()
} 