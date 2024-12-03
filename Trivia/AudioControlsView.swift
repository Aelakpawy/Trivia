import SwiftUI

struct AudioControlsView: View {
    @StateObject private var audioManager = AudioManager.shared
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                audioManager.toggleMusic()
            }) {
                Image(systemName: audioManager.isMusicEnabled ? "music.note" : "music.note.slash")
                    .foregroundColor(audioManager.isMusicEnabled ? Color(hex: "00E5FF") : .gray)
            }
            
            Button(action: {
                audioManager.toggleSound()
            }) {
                Image(systemName: audioManager.isSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                    .foregroundColor(audioManager.isSoundEnabled ? Color(hex: "00E5FF") : .gray)
            }
        }
        .font(.title2)
    }
}
