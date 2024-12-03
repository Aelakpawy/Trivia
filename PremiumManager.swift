import SwiftUI

class PremiumManager: ObservableObject {
    static let shared = PremiumManager()
    
    @AppStorage("isPremium") private var isPremium = false
    @Published private(set) var isLoading = false
    
    private init() {}
    
    func isPremiumFeatureAvailable() -> Bool {
        return isPremium
    }
    
    func showPremiumRequired() -> Alert {
        return Alert(
            title: Text("Premium Required"),
            message: Text("This feature requires a premium subscription. Unlock all features and enjoy an ad-free experience!"),
            primaryButton: .default(Text("Learn More"), action: {
                NotificationCenter.default.post(name: .showPremiumStore, object: nil)
            }),
            secondaryButton: .cancel()
        )
    }
    
    func purchasePremium() async throws {
        // Simulate network request
        isLoading = true
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds delay
        
        // Update premium status
        isPremium = true
        isLoading = false
        
        // Log analytics
        AnalyticsManager.shared.logEvent("premium_purchased")
    }
    
    func restorePurchases() async throws {
        isLoading = true
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        
        // Implement actual restore logic here
        isLoading = false
    }
    
    // Add this method for testing
    func resetPremiumStatus() {
        isPremium = false
        AnalyticsManager.shared.logEvent("premium_reset")
    }
}

extension Notification.Name {
    static let showPremiumStore = Notification.Name("showPremiumStore")
} 