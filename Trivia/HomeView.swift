//
//  HomeView.swift
//  Trivia
//
//  Created by ahmed.elakpawy on 29.10.24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var levelManager = LevelManager.shared
    @State private var showingLevelInfo = false
    @State private var selectedLevel: Level?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Current Progress Section
                VStack(spacing: 15) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current Level")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Image(systemName: levelManager.getCurrentLevel().image)
                                    .font(.title2)
                                Text(levelManager.getCurrentLevel().name)
                                    .font(.title3)
                                    .bold()
                            }
                            .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("Score: \(levelManager.currentTotalScore)")
                            .font(.headline)
                            .foregroundColor(Color(hex: "00E5FF"))
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
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(hex: "2E1C4A").opacity(0.6))
                )
                .padding(.horizontal)
                
                // Level Map
                VStack(alignment: .leading, spacing: 15) {
                    Text("Level Journey")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(levelManager.levels, id: \.name) { level in
                                LevelCard(
                                    level: level,
                                    isCurrentLevel: level.name == levelManager.getCurrentLevel().name,
                                    isLocked: level.minScore > levelManager.currentTotalScore
                                )
                                .onTapGesture {
                                    selectedLevel = level
                                    showingLevelInfo = true
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Leaderboard Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Top Players")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    ForEach(Array(samplePlayers.prefix(10).enumerated()), id: \.element.id) { index, player in
                        TopPlayerRow(rank: index + 1, player: player)
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
        .sheet(isPresented: $showingLevelInfo) {
            if let level = selectedLevel {
                LevelInfoView(level: level)
            }
        }
    }
}

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
                .multilineTextAlignment(.center)
            
            Text("\(level.minScore)pts")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(width: 100, height: 120)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isCurrentLevel ? Color(hex: "00E5FF").opacity(0.2) : Color(hex: "2E1C4A").opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            isCurrentLevel ? Color(hex: "00E5FF") : Color.clear,
                            lineWidth: 2
                        )
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

struct TopPlayerRow: View {
    let rank: Int
    let player: Player
    
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
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "2E1C4A").opacity(0.6))
        )
    }
}

struct LevelInfoView: View {
    let level: Level
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: level.image)
                    .font(.system(size: 60))
                    .foregroundColor(Color(hex: "00E5FF"))
                
                Text(level.name)
                    .font(.title2)
                    .bold()
                
                VStack(alignment: .leading, spacing: 15) {
                    InfoRow(title: "Required Score", value: "\(level.minScore) points")
                    InfoRow(title: "Max Score", value: "\(level.maxScore) points")
                    InfoRow(title: "Perks", value: "Special achievements and badges")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(hex: "2E1C4A").opacity(0.6))
                )
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Level Details")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
    }
}
