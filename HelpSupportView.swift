import SwiftUI

struct HelpSupportView: View {
    @ObservedObject private var supportManager = SupportManager.shared
    @AppStorage("isSubscribedToNewsletter") private var isSubscribedToNewsletter = false
    
    var body: some View {
        ZStack {
            // Background gradient
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
                // SUPPORT section
                VStack(alignment: .leading, spacing: 16) {
                    Text("SUPPORT")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Contact Support Button
                    FrostedGlassButton(icon: "envelope.fill", text: "Contact Support") {
                        supportManager.sendSupportEmail()
                    }
                    .padding(.horizontal)
                    
                    // Instagram Page Button
                    FrostedGlassButton(icon: "camera.fill", text: "Instagram Page") {
                        supportManager.openInstagramPage()
                    }
                    .padding(.horizontal)
                    
                    // Newsletter Toggle Button
                    HStack {
                        Image(systemName: "newspaper.fill")
                            .foregroundColor(.blue)
                        Text("Fun Newsletter")
                            .foregroundColor(.white)
                        Spacer()
                        Toggle("", isOn: $isSubscribedToNewsletter)
                            .onChange(of: isSubscribedToNewsletter) { oldValue, newValue in
                                supportManager.handleNewsletterToggle(isSubscribed: newValue)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                    }
                    .padding()
                    .background(FrostedGlass())
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .padding(.horizontal)
                }
                
                // FAQ section
                VStack(alignment: .leading, spacing: 16) {
                    Text("FAQ")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.top, 32)
                    
                    VStack(spacing: 1) {
                        FAQRow(question: "How do I reset my password?",
                              answer: "Go to the login screen and tap 'Forgot Password'")
                        
                        Divider()
                            .background(Color.white.opacity(0.1))
                        
                        FAQRow(question: "How do premium features work?",
                              answer: "Premium features can be unlocked through in-app purchase")
                    }
                    .background(FrostedGlass())
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        // Mail configuration alert
        .alert("Mail Not Configured", isPresented: Binding(
            get: { supportManager.alertMessage != nil },
            set: { if !$0 { supportManager.alertMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            if let message = supportManager.alertMessage {
                Text(message)
            }
        }
        // Newsletter update alert
        .alert("Newsletter Update", isPresented: Binding(
            get: { supportManager.newsletterMessage != nil },
            set: { if !$0 { supportManager.newsletterMessage = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            if let message = supportManager.newsletterMessage {
                Text(message)
            }
        }
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.large)
    }
}

// Frosted Glass Background
struct FrostedGlass: View {
    var body: some View {
        ZStack {
            Color.white.opacity(0.05)
            
            // Blur effect
            Rectangle()
                .fill(.white)
                .opacity(0.05)
                .blur(radius: 10)
            
            // Gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [
                    .white.opacity(0.15),
                    .white.opacity(0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

// Frosted Glass Button
struct FrostedGlassButton: View {
    let icon: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(text)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding()
            .background(FrostedGlass())
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

struct FAQRow: View {
    let question: String
    let answer: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text(question)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
            .padding()
            
            if isExpanded {
                Text(answer)
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.bottom, 16)
            }
        }
    }
}

#Preview {
    NavigationView {
        HelpSupportView()
    }
}
