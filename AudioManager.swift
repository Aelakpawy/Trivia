import AVFoundation
import SwiftUI

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    var backgroundMusicPlayer: AVAudioPlayer?
    var correctSoundPlayer: AVAudioPlayer?
    var wrongSoundPlayer: AVAudioPlayer?
    var gameOverSoundPlayer: AVAudioPlayer?
    
    @Published private(set) var isMusicEnabled = true
    @Published private(set) var isSoundEnabled = true
    @Published private(set) var isGameInProgress = false
    
    init() {
        setupAudio()
    }
    
    private func setupAudio() {
        // Setup background music
        if let musicURL = Bundle.main.url(forResource: "background_music", withExtension: "mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusicPlayer?.numberOfLoops = -1 // Loop indefinitely
                backgroundMusicPlayer?.volume = 0.5
                print("Successfully loaded background music")
            } catch {
                print("Error loading background music: \(error.localizedDescription)")
            }
        } else {
            print("Could not find background_music.mp3")
        }
        
        // Setup sound effects
        if let correctURL = Bundle.main.url(forResource: "correct", withExtension: "mp3") {
            do {
                correctSoundPlayer = try AVAudioPlayer(contentsOf: correctURL)
                correctSoundPlayer?.volume = 0.7
                print("Successfully loaded correct sound")
            } catch {
                print("Error loading correct sound: \(error.localizedDescription)")
            }
        }
        
        if let wrongURL = Bundle.main.url(forResource: "wrong", withExtension: "mp3") {
            do {
                wrongSoundPlayer = try AVAudioPlayer(contentsOf: wrongURL)
                wrongSoundPlayer?.volume = 0.7
                print("Successfully loaded wrong sound")
            } catch {
                print("Error loading wrong sound: \(error.localizedDescription)")
            }
        }
        
        if let gameOverURL = Bundle.main.url(forResource: "game_over", withExtension: "mp3") {
            do {
                gameOverSoundPlayer = try AVAudioPlayer(contentsOf: gameOverURL)
                gameOverSoundPlayer?.volume = 0.7
                print("Successfully loaded game over sound")
            } catch {
                print("Error loading game over sound: \(error.localizedDescription)")
            }
        }
        
        // Setup audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }
    
    func playBackgroundMusic() {
        guard isMusicEnabled && isGameInProgress else { return }
        backgroundMusicPlayer?.currentTime = 0
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
        DispatchQueue.main.async {
            self.isMusicEnabled.toggle()
            if !self.isMusicEnabled {
                self.stopBackgroundMusic()
            } else if self.isGameInProgress {
                self.playBackgroundMusic()
            }
        }
    }
    
    func toggleSound() {
        DispatchQueue.main.async {
            self.isSoundEnabled.toggle()
        }
    }
    
    func setGameInProgress(_ inProgress: Bool) {
        DispatchQueue.main.async {
            self.isGameInProgress = inProgress
            if inProgress && self.isMusicEnabled {
                self.playBackgroundMusic()
            } else {
                self.stopBackgroundMusic()
            }
        }
    }
}
