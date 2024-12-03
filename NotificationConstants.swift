import Foundation

extension Notification.Name {
    // Game notifications
    static let levelUp = Notification.Name("com.AhmedElakpawy.Trivia.levelUp")
    static let gameOver = Notification.Name("com.AhmedElakpawy.Trivia.gameOver")
    static let scoreUpdate = Notification.Name("com.AhmedElakpawy.Trivia.scoreUpdate")
    
    // Challenge notifications
    static let challengeReceived = Notification.Name("com.AhmedElakpawy.Trivia.challengeReceived")
    static let challengeCompleted = Notification.Name("com.AhmedElakpawy.Trivia.challengeCompleted")
} 