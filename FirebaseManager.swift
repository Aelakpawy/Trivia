import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class FirebaseManager {
    static let shared = FirebaseManager()
    
    func configure() {
        FirebaseApp.configure()
    }
} 