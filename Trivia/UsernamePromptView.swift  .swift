import SwiftUI

struct UsernamePromptView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var username = ""
    @State private var showAlert = false
    @Binding var isLoggedIn: Bool
    @AppStorage("username") private var storedUsername = ""
    
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
            
            VStack(spacing: 30) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(Color(hex: "00E5FF"))
                    .padding()
                
                Text("Choose Your Username")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                Text("This will be displayed on the leaderboard")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                TextField("Enter username", text: $username)
                    .textFieldStyle(TriviaTextFieldStyle())
                    .padding(.horizontal, 40)
                    .autocapitalization(.none)
                
                Button("Continue") {
                    if username.isEmpty {
                        showAlert = true
                    } else {
                        storedUsername = username
                        isLoggedIn = true
                        dismiss()
                    }
                }
                .font(.headline)
                .foregroundColor(.black)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "00E5FF"))
                .cornerRadius(10)
                .padding(.horizontal, 40)
            }
            .padding()
        }
        .alert("Username Required", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please enter a username to continue")
        }
        .interactiveDismissDisabled() // Prevents dismissing by swipe
    }
}
