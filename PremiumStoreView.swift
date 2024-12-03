import SwiftUI

struct PremiumStoreView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var premiumManager = PremiumManager.shared
    @State private var showingCelebration = false
    @State private var isProcessing = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
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
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 15) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 60))
                                .foregroundColor(Color(hex: "FFD700"))
                            
                            Text("Unlock Triviaholic Premium")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            
                            Text("Get access to all features and enjoy an ad-free experience!")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        }
                        .padding(.top, 30)
                        
                        // Features
                        VStack(alignment: .leading, spacing: 20) {
                            FeatureRow(icon: "star.fill", title: "All Game Modes", description: "Access Time Attack and Challenge modes")
                            FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Detailed Statistics", description: "Track your progress in detail")
                            FeatureRow(icon: "crown.fill", title: "Premium Questions", description: "Access all difficulty levels")
                            FeatureRow(icon: "person.2.fill", title: "Multiplayer Features", description: "Challenge friends and compete")
                        }
                        .padding()
                        
                        // Purchase Button
                        Button {
                            purchasePremium()
                        } label: {
                            HStack {
                                if isProcessing {
                                    ProgressView()
                                        .tint(.black)
                                } else {
                                    Text("Unlock Premium - $4.99")
                                        .bold()
                                }
                            }
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "00E5FF"))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        }
                        .disabled(isProcessing)
                        .padding(.horizontal)
                        
                        // Restore Button
                        Button("Restore Purchases") {
                            restorePurchases()
                        }
                        .foregroundColor(Color(hex: "00E5FF"))
                        
                        #if DEBUG
                        // Reset Premium Status (Debug only)
                        Button {
                            premiumManager.resetPremiumStatus()
                            dismiss()
                        } label: {
                            Text("Reset Premium Status (Debug)")
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                        }
                        .padding(.top)
                        #endif
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "00E5FF"))
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .fullScreenCover(isPresented: $showingCelebration) {
            PremiumCelebrationView()
        }
    }
    
    private func purchasePremium() {
        isProcessing = true
        
        Task {
            do {
                try await premiumManager.purchasePremium()
                isProcessing = false
                showingCelebration = true
            } catch {
                isProcessing = false
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
    
    private func restorePurchases() {
        isProcessing = true
        
        Task {
            do {
                try await premiumManager.restorePurchases()
                isProcessing = false
                if premiumManager.isPremiumFeatureAvailable() {
                    showingCelebration = true
                }
            } catch {
                isProcessing = false
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(hex: "FFD700"))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    PremiumStoreView()
} 