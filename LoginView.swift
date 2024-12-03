import SwiftUI
import AuthenticationServices
import FirebaseAuth
import FirebaseDatabase

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var isShowingSignUp = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingUsernamePrompt = false // Add this line
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("username") private var storedUsername = ""
    @AppStorage("userEmail") private var storedEmail = ""
    
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
    
    private func handleSignUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showingAlert = true
                return
            }
            
            if let user = result?.user {
                // Save username to UserDefaults
                storedUsername = username
                storedEmail = email
                
                // Create initial user data in Firebase
                let userRef = Database.database().reference().child("users").child(user.uid)
                let userData = [
                    "username": username,
                    "email": email,
                    "createdAt": ServerValue.timestamp()
                ] as [String : Any]
                
                userRef.setValue(userData) { error, _ in
                    if let error = error {
                        alertMessage = error.localizedDescription
                        showingAlert = true
                        return
                    }
                    isLoggedIn = true
                }
            }
        }
    }
    
    private func handleLogin() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showingAlert = true
                return
            }
            
            if let user = result?.user {
                // Fetch username from Firebase
                let userRef = Database.database().reference().child("users").child(user.uid)
                userRef.observeSingleEvent(of: .value) { snapshot in
                    if let userData = snapshot.value as? [String: Any],
                       let username = userData["username"] as? String {
                        storedUsername = username
                        storedEmail = email
                        isLoggedIn = true
                    }
                }
            }
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
