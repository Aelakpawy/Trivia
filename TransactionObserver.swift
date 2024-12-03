import StoreKit
import SwiftUI

class TransactionObserver: ObservableObject {
    static let shared = TransactionObserver()
    @AppStorage("isPremium") private var isPremium = false
    
    init() {
        Task {
            await observeTransactions()
        }
    }
    
    @MainActor
    func observeTransactions() async {
        for await verification in Transaction.updates {
            guard case .verified(let transaction) = verification else {
                continue
            }
            
            if transaction.productID == "com.AhmedElakpawy.Trivia.PremiumUnlock" {
                isPremium = true
            }
            
            await transaction.finish()
        }
    }
} 