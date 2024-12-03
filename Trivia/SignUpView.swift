import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var username = ""
    @Environment(\.dismiss) private var dismiss
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false
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
            
            ScrollView {
                VStack(spacing: 25) {
                    Text("Create Account")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    
                    VStack(spacing: 15) {
                        Text("Username")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        TextField("Enter your username", text: $username)
                            .textFieldStyle(TriviaTextFieldStyle())
                            .autocapitalization(.none)
                        
                        Text("Email")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        TextField("Enter your email", text: $email)
                            .textFieldStyle(TriviaTextFieldStyle())
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                        
                        Text("Password")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        SecureField("Enter your password", text: $password)
                            .textFieldStyle(TriviaTextFieldStyle())
                        
                        Text("Confirm Password")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        SecureField("Confirm your password", text: $confirmPassword)
                            .textFieldStyle(TriviaTextFieldStyle())
                    }
                    .padding(.horizontal, 20)
                    
                    Button("Sign Up") {
                        handleSignUp()
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "00E5FF"))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    
                    Button("Already have an account? Sign In") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "00E5FF"))
                }
                .padding(.bottom, 30)
            }
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func handleSignUp() {
        // First validate all inputs
        if username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            alertMessage = "Please fill in all fields"
            showingAlert = true
            return
        }
        
        if password != confirmPassword {
            alertMessage = "Passwords don't match"
            showingAlert = true
            return
        }
        
        // Validate password strength
        if !SecurityManager.shared.isPasswordValid(password) {
            alertMessage = "Password must be at least 8 characters and contain uppercase, lowercase, number, and special character"
            showingAlert = true
            return
        }
        
        // Hash password and save to keychain
        let hashedPassword = SecurityManager.shared.hashPassword(password)
        if SecurityManager.shared.saveToKeychain(username: email, password: hashedPassword) {
            // Store non-sensitive data
            storedUsername = username
            UserDefaults.standard.set(email, forKey: "userEmail")
            
            // Set login state to true
            isLoggedIn = true
            dismiss()
        } else {
            alertMessage = "Failed to create account. Please try again."
            showingAlert = true
        }
    }
}
