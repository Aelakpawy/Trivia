import AVFoundation
import SwiftUI

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    var backgroundMusicPlayer: AVAudioPlayer?
    var correctSoundPlayer: AVAudioPlayer?
    var wrongSoundPlayer: AVAudioPlayer?
    var gameOverSoundPlayer: AVAudioPlayer?
    
    @Published var isMusicEnabled = true
    @Published var isSoundEnabled = true
    
    init() {
        setupAudio()
    }
    
    private func setupAudio() {
        // Setup background music
        if let musicURL = Bundle.main.url(forResource: "background_music", withExtension: "mp3") {
            backgroundMusicPlayer = try? AVAudioPlayer(contentsOf: musicURL)
            backgroundMusicPlayer?.numberOfLoops = -1 // Loop indefinitely
            backgroundMusicPlayer?.volume = 0.5
        }
        
        // Setup sound effects
        if let correctURL = Bundle.main.url(forResource: "correct", withExtension: "mp3") {
            correctSoundPlayer = try? AVAudioPlayer(contentsOf: correctURL)
            correctSoundPlayer?.volume = 0.7
        }
        
        if let wrongURL = Bundle.main.url(forResource: "wrong", withExtension: "mp3") {
            wrongSoundPlayer = try? AVAudioPlayer(contentsOf: wrongURL)
            wrongSoundPlayer?.volume = 0.7
        }
        
        if let gameOverURL = Bundle.main.url(forResource: "game_over", withExtension: "mp3") {
            gameOverSoundPlayer = try? AVAudioPlayer(contentsOf: gameOverURL)
            gameOverSoundPlayer?.volume = 0.7
        }
    }
    
    func playBackgroundMusic() {
        guard isMusicEnabled else { return }
        backgroundMusicPlayer?.currentTime = 0 // Reset to beginning
        backgroundMusicPlayer?.play()
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer?.currentTime = 0
    }
    
    func playCorrectSound() {
        guard isSoundEnabled else { return }
        correctSoundPlayer?.play()
    }
    
    func playWrongSound() {
        guard isSoundEnabled else { return }
        wrongSoundPlayer?.play()
    }
    
    func playGameOverSound() {
        guard isSoundEnabled else { return }
        gameOverSoundPlayer?.play()
    }
    
    func toggleMusic() {
            isMusicEnabled.toggle()
            if !isMusicEnabled {
                stopBackgroundMusic()
            } else if GameLogic().isGameInProgress {  // This was causing the warning
                playBackgroundMusic()
            }
        }
    
    func toggleSound() {
        isSoundEnabled.toggle()
    }
}
