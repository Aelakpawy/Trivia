import SwiftUI

class AnalyticsManager: ObservableObject {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        // Implement your analytics logging here
        print("Analytics Event: \(name), Parameters: \(parameters ?? [:])")
    }
    
    func logScreen(_ name: String) {
        // Implement screen view logging here
        print("Screen View: \(name)")
    }
} 