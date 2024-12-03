//
//  SecurityManager.swift
//  Trivia
//
//  Created by ahmed.elakpawy on 31.10.24.
//

// First, let's create a new SecurityManager class to handle all security-related operations
// Create a new file called SecurityManager.swift

import Foundation
import CryptoKit
import Security

class SecurityManager {
    static let shared = SecurityManager()
    
    private init() {}
    
    // MARK: - Keychain Operations
    
    func saveToKeychain(username: String, password: String) -> Bool {
        // Convert password to data
        guard let passwordData = password.data(using: .utf8) else {
            return false
        }
        
        // Create query dictionary for keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: passwordData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add the new item
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func getFromKeychain(username: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data,
               let password = String(data: retrievedData, encoding: .utf8) {
                return password
            }
        }
        return nil
    }
    
    // MARK: - Password Validation
    
    func isPasswordValid(_ password: String) -> Bool {
        // Password must be at least 8 characters
        guard password.count >= 8 else { return false }
        
        // Must contain at least one uppercase letter
        guard password.contains(where: { $0.isUppercase }) else { return false }
        
        // Must contain at least one lowercase letter
        guard password.contains(where: { $0.isLowercase }) else { return false }
        
        // Must contain at least one number
        guard password.contains(where: { $0.isNumber }) else { return false }
        
        // Must contain at least one special character
        let specialCharacters = CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:,.<>?")
        guard password.unicodeScalars.contains(where: specialCharacters.contains) else { return false }
        
        return true
    }
    
    // MARK: - Password Hashing
    
    func hashPassword(_ password: String) -> String {
        let salt = UUID().uuidString
        let saltedPassword = password + salt
        let hashedData = SHA256.hash(data: saltedPassword.data(using: .utf8)!)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
}
