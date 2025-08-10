//
//  UserProfile.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI
import Foundation

class AccountViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var userProfile: UserProfile
    @Published var monthlyStats: MonthlyStats
    @Published var sustainabilityScore: SustainabilityScore
    @Published var appSettings: AppSettings
    
    // MARK: - UI State
    @Published var showEditProfile = false
    @Published var showSettings = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Initialization
    init() {
        // Initialize with mock data - in real app, this would come from a service
        self.userProfile = UserProfile(
            name: "Sinan Dinç",
            email: "sinandinc77@icloud.com",
            phone: "+90 555 123 4567",
            isPremium: true
        )
        
        self.monthlyStats = MonthlyStats(
            deliveries: 8,
            co2Savings: 2.4,
            favoriteProducts: 12
        )
        
        self.sustainabilityScore = SustainabilityScore(
            totalScore: 85,
            rating: 4.2,
            organicPreference: 0.9,
            packagingReduction: 0.7,
            localProducerSupport: 0.8
        )
        
        self.appSettings = AppSettings(
            notificationsEnabled: true,
            darkModeEnabled: false,
            language: "Türkçe"
        )
    }
    
    // MARK: - Profile Actions
    func updateProfile(name: String, email: String, phone: String) {
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.userProfile.name = name
            self.userProfile.email = email
            self.userProfile.phone = phone
            self.isLoading = false
            self.showEditProfile = false
        }
    }
    
    func updateProfilePhoto() {
        // Handle profile photo update
        print("Profile photo update requested")
    }
    
    // MARK: - Settings Actions
    func toggleNotifications() {
        appSettings.notificationsEnabled.toggle()
        saveSettings()
    }
    
    func toggleDarkMode() {
        appSettings.darkModeEnabled.toggle()
        saveSettings()
    }
    
    func changeLanguage(_ language: String) {
        appSettings.language = language
        saveSettings()
    }
    
    private func saveSettings() {
        // Save settings to UserDefaults or send to API
        UserDefaults.standard.set(appSettings.notificationsEnabled, forKey: "notificationsEnabled")
        UserDefaults.standard.set(appSettings.darkModeEnabled, forKey: "darkModeEnabled")
        UserDefaults.standard.set(appSettings.language, forKey: "language")
    }
    
    // MARK: - Navigation Actions
    func showPersonalInfo() {
        showEditProfile = true
    }
    
    func showAddresses() {
        print("Navigate to addresses")
    }
    
    func showPaymentMethods() {
        print("Navigate to payment methods")
    }
    
    func showOrderHistory() {
        print("Navigate to order history")
    }
    
    func showFavorites() {
        print("Navigate to favorites")
    }
    
    func showReviews() {
        print("Navigate to reviews")
    }
    
    func showAllStats() {
        print("Navigate to all stats")
    }
    
    // MARK: - Support Actions
    func showHelpCenter() {
        print("Navigate to help center")
    }
    
    func contactSupport() {
        print("Navigate to contact support")
    }
    
    func rateApp() {
        print("Navigate to app rating")
    }
    
    func logout() {
        // Handle logout logic
        print("User logout requested")
    }
    
    // MARK: - Data Loading
    func loadUserData() {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // In real app, load data from API
            self.isLoading = false
        }
    }
    
    func refreshData() {
        loadUserData()
    }
}
