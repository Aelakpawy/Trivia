import StoreKit

@MainActor
class StoreManager: ObservableObject {
    static let shared = StoreManager()
    private let productId = "com.AhmedElakpawy.Trivia.PremiumUnlock"
    
    @Published private(set) var product: Product?
    @Published private(set) var purchaseError: String?
    
    private init() {
        Task {
            await loadProducts()
        }
    }
    
    func loadProducts() async {
        do {
            let products = try await Product.products(for: [productId])
            self.product = products.first
        } catch {
            print("Failed to load products:", error)
        }
    }
    
    func purchase() async throws -> Bool {
        guard let product = product else {
            throw StoreError.productNotFound
        }
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            // Verify the purchase
            switch verification {
            case .verified(let transaction):
                // Handle successful purchase
                await transaction.finish()
                return true
            case .unverified:
                throw StoreError.failedVerification
            }
        case .userCancelled:
            return false
        case .pending:
            throw StoreError.pending
        @unknown default:
            throw StoreError.unknown
        }
    }
    
    func restorePurchases() async throws {
        try await AppStore.sync()
    }
}

enum StoreError: Error {
    case productNotFound
    case purchaseFailed
    case failedVerification
    case pending
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .productNotFound:
            return "Product not found"
        case .purchaseFailed:
            return "Purchase failed"
        case .failedVerification:
            return "Purchase verification failed"
        case .pending:
            return "Purchase is pending"
        case .unknown:
            return "An unknown error occurred"
        }
    }
} 