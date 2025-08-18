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
    
    // MARK: - UI State
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
    }
    
}
