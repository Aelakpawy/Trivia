import FirebaseDatabase
import FirebaseAuth

class LeaderboardManager: ObservableObject {
    static let shared = LeaderboardManager()
    private let database = Database.database().reference()
    private var authListener: AuthStateDidChangeListenerHandle?
    
    @Published var topPlayers: [LeaderboardEntry] = []
    @Published var isLoading = false
    @Published var userRank: Int = 0
    @Published var error: String?
    
    init() {
        // Listen for auth state changes
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if user != nil {
                // Use Task to call async function
                Task {
                    await self?.fetchLeaderboard()
                }
            } else {
                DispatchQueue.main.async {
                    self?.topPlayers = []
                    self?.userRank = 0
                }
            }
        }
    }
    
    deinit {
        // Remove the listener when the manager is deallocated
        if let listener = authListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    struct LeaderboardEntry: Identifiable, Codable {
        let id: String
        let username: String
        let score: Int
        let level: String
        let accuracy: Double
        let gamesPlayed: Int
        let lastUpdated: TimeInterval
        
        var formattedDate: String {
            let date = Date(timeIntervalSince1970: lastUpdated)
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
    
    func updateUserScore(score: Int, level: String, accuracy: Double, gamesPlayed: Int) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: No authenticated user")
            return
        }
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            print("Error: No username found")
            return
        }
        
        print("Updating score for user: \(username)")
        print("Score: \(score), Level: \(level), Accuracy: \(accuracy)")
        
        let entry = [
            "username": username,
            "score": score,
            "level": level,
            "accuracy": accuracy,
            "gamesPlayed": gamesPlayed,
            "lastUpdated": ServerValue.timestamp()
        ] as [String : Any]
        
        database.child("leaderboard").child(userId).setValue(entry) { [weak self] error, _ in
            if let error = error {
                print("Error updating leaderboard: \(error.localizedDescription)")
            } else {
                print("Successfully updated leaderboard")
                Task {
                    try? await Task.sleep(nanoseconds: 1_000_000_000) // Wait 1 second
                    await self?.fetchLeaderboard()
                }
            }
        }
    }
    
    func fetchLeaderboard() async {
        guard Auth.auth().currentUser != nil else {
            DispatchQueue.main.async {
                self.error = "Please log in to view leaderboard"
                self.isLoading = false
            }
            return
        }
        
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                self.isLoading = true
            }
            
            database.child("leaderboard")
                .queryOrdered(byChild: "score")
                .queryLimited(toLast: 100)
                .observeSingleEvent(of: .value) { [weak self] snapshot in
                    guard let self = self else {
                        continuation.resume()
                        return
                    }
                    
                    // Create entries array in local scope
                    let entries = snapshot.children.allObjects.compactMap { child -> LeaderboardEntry? in
                        guard let child = child as? DataSnapshot,
                              let dict = child.value as? [String: Any],
                              let username = dict["username"] as? String,
                              let score = dict["score"] as? Int,
                              let level = dict["level"] as? String,
                              let accuracy = dict["accuracy"] as? Double,
                              let gamesPlayed = dict["gamesPlayed"] as? Int,
                              let lastUpdated = dict["lastUpdated"] as? TimeInterval
                        else { return nil }
                        
                        return LeaderboardEntry(
                            id: child.key,
                            username: username,
                            score: score,
                            level: level,
                            accuracy: accuracy,
                            gamesPlayed: gamesPlayed,
                            lastUpdated: lastUpdated
                        )
                    }
                    
                    // Sort entries
                    let sortedEntries = entries.sorted { $0.score > $1.score }
                    
                    // Update UI on main thread
                    DispatchQueue.main.async {
                        self.topPlayers = sortedEntries
                        self.isLoading = false
                        
                        // Find user's rank
                        if let userId = Auth.auth().currentUser?.uid {
                            self.userRank = sortedEntries.firstIndex { $0.id == userId }
                                .map { $0 + 1 } ?? 0
                        }
                    }
                    
                    continuation.resume()
                }
        }
    }
} 
