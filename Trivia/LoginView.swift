import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isShowingSignUp = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingUsernamePrompt = false // Add this line
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
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
                // Keep all your existing content exactly the same
                VStack(spacing: 25) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 80))
                        .foregroundColor(Color(hex: "00E5FF"))
                        .padding(.top, 60)
                    
                    Text("Welcome Back")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                    VStack(spacing: 15) {
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
                        
                        Button("Forgot Password?") {
                            // Handle forgot password
                        }
                        .font(.footnote)
                        .foregroundColor(Color(hex: "00E5FF"))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 20)
                    }
                    .padding(.horizontal, 20)
                    
                    Button("Sign In") {
                        handleLogin()
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "00E5FF"))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 20) {
                        HStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray.opacity(0.5))
                            
                            Text("OR")
                                .foregroundColor(.gray)
                                .font(.caption)
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray.opacity(0.5))
                        }
                        .padding(.horizontal, 20)
                        
                        // Apple Sign In Button
                        SignInWithAppleButton { request in
                            request.requestedScopes = [.email, .fullName]
                        } onCompletion: { result in
                            handleAppleSignIn(result)
                        }
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        Button("Sign Up") {
                            isShowingSignUp = true
                        }
                        .foregroundColor(Color(hex: "00E5FF"))
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .sheet(isPresented: $isShowingSignUp) {
            SignUpView()
        }
        .sheet(isPresented: $showingUsernamePrompt) { // Add this sheet
            UsernamePromptView(isLoggedIn: $isLoggedIn)
        }
    }
    
    private func handleLogin() {
        if email.isEmpty || password.isEmpty {
            alertMessage = "Please fill in all fields"
            showingAlert = true
            return
        }
        
        // Get stored password from keychain
        if let storedPassword = SecurityManager.shared.getFromKeychain(username: email) {
            // Hash the entered password and compare
            let hashedEnteredPassword = SecurityManager.shared.hashPassword(password)
            
            if hashedEnteredPassword == storedPassword {
                isLoggedIn = true
            } else {
                alertMessage = "Invalid email or password"
                showingAlert = true
            }
        } else {
            alertMessage = "Invalid email or password"
            showingAlert = true
        }
    }
    
    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // Handle successful Apple sign in
                print("Successfully signed in with Apple")
                if let email = appleIDCredential.email {
                    print("User Email: \(email)")
                    UserDefaults.standard.set(email, forKey: "userEmail")
                }
                if let fullName = appleIDCredential.fullName {
                    let firstName = fullName.givenName ?? ""
                    let lastName = fullName.familyName ?? ""
                    print("User Name: \(firstName) \(lastName)")
                }
                // Instead of directly setting isLoggedIn, show username prompt
                showingUsernamePrompt = true
            }
        case .failure(let error):
            alertMessage = error.localizedDescription
            showingAlert = true
        }
    }
}
