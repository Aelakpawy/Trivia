import SwiftUI

struct ContentView: View {
    @StateObject private var legalManager = LegalManager.shared
    @State private var showingLegalTerms = false
    
    var body: some View {
        Group {
            if legalManager.needsToAcceptTerms() {
                LegalTermsView {
                    showingLegalTerms = false
                }
            } else {
                // Your existing app content
                MainContentView()
            }
        }
        .onAppear {
            showingLegalTerms = legalManager.needsToAcceptTerms()
        }
    }
}
