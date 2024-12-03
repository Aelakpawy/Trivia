//
//  Models.swift
//  Trivia
//
//  Created by ahmed.elakpawy on 29.10.24.
//

import Foundation

struct Player: Identifiable {
    let id = UUID()
    let name: String
    let score: Int
    let level: String
}

// Sample data
let samplePlayers = [
    Player(name: "John Doe", score: 2500, level: "Einstein"),
    Player(name: "Jane Smith", score: 2300, level: "Brainiac Genius"),
    Player(name: "Mike Johnson", score: 2100, level: "Professor"),
    Player(name: "Sarah Williams", score: 2000, level: "Mastermind"),
    Player(name: "Tom Brown", score: 1900, level: "Clever Sage"),
    Player(name: "Lisa Anderson", score: 1800, level: "Trivia Challenger"),
    Player(name: "James Wilson", score: 1700, level: "Quiz Whiz"),
    Player(name: "Emma Davis", score: 1600, level: "Smarty Pants"),
    Player(name: "David Miller", score: 1500, level: "Knowledge Explorer"),
    Player(name: "Olivia Taylor", score: 1400, level: "Junior Scholar")
]
