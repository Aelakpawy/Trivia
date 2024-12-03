import Foundation
import SwiftUI
#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

struct IQTestResult: Codable, Identifiable {
    let id: UUID
    let score: Int
    let date: Date
    let category: String
    let percentile: Double
    
    var description: String {
        switch score {
        case 130...200: return "Very Superior"
        case 120...129: return "Superior"
        case 110...119: return "High Average"
        case 90...109: return "Average"
        case 80...89: return "Low Average"
        case 70...79: return "Borderline"
        default: return "Extremely Low"
        }
    }
}

@MainActor
class IQTestManager: ObservableObject {
    static let shared = IQTestManager()
    @Published private(set) var results: [IQTestResult] = []
    @Published private(set) var latestScore: Int?
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadResults()
    }
    
    func saveResult(_ score: Int, category: String) {
        let result = IQTestResult(
            id: UUID(),
            score: score,
            date: Date(),
            category: category,
            percentile: calculatePercentile(score)
        )
        
        results.append(result)
        latestScore = score
        saveResults()
    }
    
    private func calculatePercentile(_ score: Int) -> Double {
        // Simple percentile calculation based on normal distribution
        let mean = 100.0
        let standardDeviation = 15.0
        let z = (Double(score) - mean) / standardDeviation
        #if canImport(Darwin)
        return (1 + Darwin.erf(z / sqrt(2))) / 2 * 100
        #else
        return (1 + Glibc.erf(z / sqrt(2))) / 2 * 100
        #endif
    }
    
    private func loadResults() {
        if let data = userDefaults.data(forKey: "iqTestResults"),
           let decoded = try? JSONDecoder().decode([IQTestResult].self, from: data) {
            results = decoded
            latestScore = results.last?.score
        }
    }
    
    private func saveResults() {
        if let encoded = try? JSONEncoder().encode(results) {
            userDefaults.set(encoded, forKey: "iqTestResults")
        }
    }
} 