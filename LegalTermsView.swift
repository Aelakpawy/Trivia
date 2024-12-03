import SwiftUI

struct LegalTermsView: View {
    @StateObject private var legalManager = LegalManager.shared
    @State private var hasAccepted = false
    let completion: () -> Void
    
    // Update these URLs to your actual privacy policy and terms URLs
    private let termsURL = "https://yourdomain.com/terms"
    private let privacyURL = "https://yourdomain.com/privacy"
    
    var body: some View {
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
                VStack(spacing: 25) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color(hex: "00E5FF"))
                        .padding(.top, 40)
                    
                    Text("Terms & Privacy Policy")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("Before you continue, please read and accept our Terms of Service and Privacy Policy.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // Terms of Service Link
                        Button(action: {
                            if let url = URL(string: termsURL) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Text("Terms of Service")
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                            }
                            .foregroundColor(Color(hex: "00E5FF"))
                        }
                        
                        // Privacy Policy Link
                        Button(action: {
                            if let url = URL(string: privacyURL) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Text("Privacy Policy")
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                            }
                            .foregroundColor(Color(hex: "00E5FF"))
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Acceptance Toggle
                    Toggle(isOn: $hasAccepted) {
                        Text("I accept the Terms of Service and Privacy Policy")
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                    .padding()
                    .tint(Color(hex: "00E5FF"))
                    
                    // Continue Button
                    Button(action: {
                        legalManager.acceptTerms()
                        completion()
                    }) {
                        Text("Continue")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(
                                hasAccepted ? Color(hex: "00E5FF") : Color.gray
                            )
                            .cornerRadius(12)
                    }
                    .disabled(!hasAccepted)
                    .padding(.horizontal)
                    .padding(.top)
                }
                .padding(.bottom, 30)
            }
        }
    }
} 