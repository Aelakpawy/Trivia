//
//  HomeView.swift
//  Trivia
//
//  Created by ahmed.elakpawy on 29.10.24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var levelManager = LevelManager.shared
    @State private var isRefreshing = false
    @State private var isLoading = false
    @State private var showLoadingOverlay = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Current Progress Section with simple border
                VStack(spacing: 15) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current Level")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 12) {
                                Image(systemName: levelManager.getCurrentLevel().image)
                                    .font(.title2)
                                    .foregroundColor(Color(hex: "00E5FF"))
                                    .symbolEffect(.bounce, options: .repeating, value: isRefreshing)
                                
                                Text(levelManager.getCurrentLevel().name)
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                        ScoreView(score: levelManager.currentTotalScore)
                    }
                    
                    if let nextLevel = levelManager.getNextLevel() {
                        ProgressView(value: levelManager.getProgressToNextLevel()) {
                            HStack {
                                Text("Next Level: \(nextLevel.name)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(nextLevel.minScore - levelManager.currentTotalScore) points to go")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .tint(Color(hex: "00E5FF"))
                    }
                }
                .padding()
                .background(Color(hex: "2E1C4A"))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 1)
                )
                .padding(.horizontal)
                
                // Level Journey Section
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Level Journey")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Swipe to explore →")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(levelManager.levels, id: \.name) { level in
                                    LevelCard(
                                        level: level,
                                        isCurrentLevel: level.name == levelManager.getCurrentLevel().name,
                                        isLocked: level.minScore > levelManager.currentTotalScore
                                    )
                                    .id(level.name)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .onAppear {
                            withAnimation {
                                proxy.scrollTo(levelManager.getCurrentLevel().name)
                            }
                        }
                    }
                }
                
                // Top Players Section
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Top Players")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                        
                        Image(systemName: "crown.fill")
                            .foregroundColor(Color(hex: "FFD700"))
                            .symbolEffect(.bounce, options: .repeating)
                    }
                    .padding(.horizontal)
                    
                    ForEach(Array(samplePlayers.prefix(5).enumerated()), id: \.element.id) { index, player in
                        TopPlayerRow(rank: index + 1, player: player)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "2E1C4A"),
                    Color(hex: "0F1C4D")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .refreshable {
            isRefreshing = true
            showLoadingOverlay = true
            
            do {
                try await Task.sleep(nanoseconds: 1_500_000_000)
                await refreshData()
            } catch {
                // Handle error
            }
            
            showLoadingOverlay = false
            isRefreshing = false
        }
        .overlay {
            if showLoadingOverlay {
                LoadingOverlay(message: "Updating...")
                    .transition(.opacity)
            }
        }
    }
    
    func refreshData() async {
        HapticManager.shared.medium()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        HapticManager.shared.success()
    }
}

// Update TopPlayerRow with frosted glass effect
struct TopPlayerRow: View {
    let rank: Int
    let player: Player
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 15) {
            Text("#\(rank)")
                .font(.headline)
                .foregroundColor(rank <= 3 ? Color(hex: "00E5FF") : .gray)
                .frame(width: 40)
            
            Image(systemName: "person.circle.fill")
                .font(.title2)
                .foregroundColor(Color(hex: "00E5FF"))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text(player.level)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("\(player.score)")
                .font(.headline)
                .foregroundColor(Color(hex: "00E5FF"))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.1))
                .background(
                    Color.white.opacity(0.05)
                        .blur(radius: 10)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.5),
                                    .clear,
                                    .white.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .scaleEffect(isHovered ? 1.02 : 1)
        .animation(.spring(response: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
            if hovering {
                HapticManager.shared.selection()
            }
        }
    }
}

// Update LevelCard with simpler design
struct LevelCard: View {
    let level: Level
    let isCurrentLevel: Bool
    let isLocked: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: level.image)
                .font(.system(size: 30))
                .foregroundColor(isLocked ? .gray : Color(hex: "00E5FF"))
            
            Text(level.name)
                .font(.caption)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("\(level.minScore)pts")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(width: 100, height: 120)
        .padding()
        .background(Color(hex: "2E1C4A"))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(
                    isCurrentLevel ? Color(hex: "00E5FF") : Color.white.opacity(0.1),
                    lineWidth: isCurrentLevel ? 2 : 1
                )
        )
        .overlay(
            Group {
                if isLocked {
                    Color.black.opacity(0.4)
                        .cornerRadius(15)
                        .overlay(
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                        )
                }
            }
        )
    }
}

// Update ScoreView with simpler design
struct ScoreView: View {
    let score: Int
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "star.fill")
                .foregroundColor(Color(hex: "00E5FF"))
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .onAppear {
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        isAnimating = true
                    }
                }
            
            Text("\(score)")
                .font(.headline)
                .foregroundColor(Color(hex: "00E5FF"))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(hex: "2E1C4A"))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
