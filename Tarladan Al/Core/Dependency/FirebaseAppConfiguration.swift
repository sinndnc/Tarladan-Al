//
//  FirebaseAppConfiguration.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//


import Foundation
import Firebase
import FirebaseAuth

class FirebaseAppConfiguration {
    
    static let shared = FirebaseAppConfiguration()
    
    private init() {}
    
    func configure() {
        
        FirebaseApp.configure()
        
        // Configure Auth settings
        configureAuth()
    }
    
    private func configureAuth() {
        // Enable persistence for offline support
        Auth.auth().useAppLanguage()
        
        // Set custom timeout
        // Auth.auth().settings?.appVerificationDisabledForTesting = false // Only for testing
    }
    
    func removeAuthStateListener(_ handle: AuthStateDidChangeListenerHandle) {
        Auth.auth().removeStateDidChangeListener(handle)
    }
}
