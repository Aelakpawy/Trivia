import Foundation
import SwiftUI

class ChallengeManager: ObservableObject {
    static let shared = ChallengeManager()
    
    @Published var activeChallenges: [Challenge] = []
    @Published var pendingChallenges: [Challenge] = []
    
    struct Challenge: Identifiable, Codable {
        let id: UUID
        let challengerId: String
        let challengerName: String
        let challengeeId: String
        let challengeeName: String
        let questions: [Question]
        let timeLimit: Int
        let status: ChallengeStatus
        let createdAt: Date
        var results: ChallengeResults?
    }
    
    enum ChallengeStatus: String, Codable {
        case pending
        case active
        case completed
        case expired
    }
    
    struct ChallengeResults: Codable {
        let challengerScore: Int
        let challengeeScore: Int
        let challengerTime: TimeInterval
        let challengeeTime: TimeInterval
    }
    
    func createChallenge(challengeeUsername: String) -> Challenge? {
        guard let currentUser = UserDefaults.standard.string(forKey: "username") else { return nil }
        
        let challenge = Challenge(
            id: UUID(),
            challengerId: currentUser,
            challengerName: currentUser,
            challengeeId: challengeeUsername,
            challengeeName: challengeeUsername,
            questions: Array(QuestionBank.allQuestions.shuffled().prefix(10)),
            timeLimit: 60,
            status: .pending,
            createdAt: Date(),
            results: nil
        )
        
        pendingChallenges.append(challenge)
        return challenge
    }
    
    func createQuickChallenge() -> Challenge? {
        guard let currentUser = UserDefaults.standard.string(forKey: "username") else { return nil }
        
        let challenge = Challenge(
            id: UUID(),
            challengerId: currentUser,
            challengerName: currentUser,
            challengeeId: "anyone",
            challengeeName: "Anyone",
            questions: Array(QuestionBank.allQuestions.shuffled().prefix(10)),
            timeLimit: 60,
            status: .pending,
            createdAt: Date(),
            results: nil
        )
        
        pendingChallenges.append(challenge)
        return challenge
    }
    
    func generateChallengeLink(for challenge: Challenge) -> URL? {
        var components = URLComponents()
        components.scheme = "trivia"
        components.host = "challenge"
        components.queryItems = [
            URLQueryItem(name: "id", value: challenge.id.uuidString),
            URLQueryItem(name: "challenger", value: challenge.challengerName),
            URLQueryItem(name: "mode", value: "challenge")
        ]
        return components.url
    }
}

// Add ChallengeRow view
struct ChallengeRow: View {
    let challenge: ChallengeManager.Challenge
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(challenge.challengerName) vs \(challenge.challengeeName)")
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack {
                    Image(systemName: challenge.status == .pending ? "clock.fill" : "gamecontroller.fill")
                        .foregroundColor(challenge.status == .pending ? Color(hex: "FFB86C") : Color(hex: "00E5FF"))
                    Text(challenge.status.rawValue.capitalized)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Button(action: {
                // Handle accept/play action
                HapticManager.shared.medium()
            }) {
                Text(challenge.status == .pending ? "Accept" : "Play")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(hex: "00E5FF"))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}