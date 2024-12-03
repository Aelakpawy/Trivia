import SwiftUI

class LegalManager: ObservableObject {
    static let shared = LegalManager()
    
    @AppStorage("hasAcceptedTerms") private(set) var hasAcceptedTerms = false
    @AppStorage("termsAcceptanceDate") private(set) var termsAcceptanceDate: Double?
    @AppStorage("privacyPolicyVersion") private(set) var acceptedPrivacyPolicyVersion: String?
    
    private let currentPrivacyPolicyVersion = "1.0" // Update this when policy changes
    
    func acceptTerms() {
        hasAcceptedTerms = true
        termsAcceptanceDate = Date().timeIntervalSince1970
        acceptedPrivacyPolicyVersion = currentPrivacyPolicyVersion
        AnalyticsManager.shared.logEvent("legal_terms_accepted")
    }
    
    func needsToAcceptTerms() -> Bool {
        return !hasAcceptedTerms || acceptedPrivacyPolicyVersion != currentPrivacyPolicyVersion
    }
} 