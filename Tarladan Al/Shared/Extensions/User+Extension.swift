//
//  User+Extension.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//

import Foundation


extension User {
    
    
  
    init(fromDTO dto: SignInResponseDTO) {
        let now = Date()
        let displayNameParts = dto.displayName?.components(separatedBy: " ") ?? ["", ""]
        
        self.email = dto.email ?? ""
        self.firstName = displayNameParts.first ?? ""
        self.lastName = displayNameParts.dropFirst().joined(separator: " ")
        self.phone = ""
        
        // Account Status
        self.isActive = true
        self.isVerified = dto.emailVerified
        self.emailVerified = dto.emailVerified
        self.phoneVerified = false
        
        // Timestamps - metadata'dan parse et
        self.createdAt = Self.parseDate(from: dto.metadata?.creationTime) ?? now
        self.updatedAt = now
        self.lastLogin = Self.parseDate(from: dto.metadata?.lastSignInTime)
        
        // Default preferences
        self.language = Locale.current.language.languageCode?.identifier ?? "en"
        self.currency = Locale.current.currency?.identifier ?? "USD"
        self.timeZone = TimeZone.current.identifier
        self.newsletterOptIn = false
        self.smsOptIn = false
        
        // Empty collections - bunlar daha sonra API'den yüklenecek
        self.addresses = []
        self.paymentMethods = []
        self.dietaryPrefs = DietaryPreference()
        self.subscription = nil
        
        // Default values
        self.customerNotes = ""
        self.loyaltyPoints = 0
        self.referralCode = Self.generateReferralCode(from: dto.displayName ?? dto.email ?? dto.uid)
        
        // Analytics
        self.utmSource = nil
        self.utmCampaign = nil
        self.referredBy = nil
        
        // Business metrics - başlangıç değerleri
        self.totalOrders = 0
        self.totalSpent = 0.0
        self.averageOrder = 0.0
        self.lastOrderDate = nil
        self.profileImageUrl = ""
    }
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var initials: String {
        let firstInitial = firstName.first?.uppercased() ?? ""
        let lastInitial = lastName.first?.uppercased() ?? ""
        return firstInitial + lastInitial
    }
    
    var defaultAddress: Address? {
        addresses.first { $0.isDefault } ?? addresses.first
    }
    
    var defaultPaymentMethod: PaymentMethod? {
        paymentMethods.first { $0.isDefault } ?? paymentMethods.first
    }
    
    var hasActiveSubscription: Bool {
        subscription?.isActive == true
    }
    
    var canReceiveMarketing: Bool {
        newsletterOptIn || smsOptIn
    }
    
    var isLoyalCustomer: Bool {
        totalOrders >= 10 || totalSpent >= 500.0
    }
    
    var subscriptionStatus: String {
        guard let subscription = subscription else { return "No Subscription" }
        
        if !subscription.isActive {
            return "Inactive"
        }
        
        if let pausedUntil = subscription.pausedUntil, pausedUntil > Date() {
            return "Paused"
        }
        
        return "Active"
    }
    
    var membershipTier: String {
        switch totalSpent {
        case 0..<100:
            return "Bronze"
        case 100..<500:
            return "Silver"
        case 500..<1000:
            return "Gold"
        default:
            return "Platinum"
        }
    }
    
    static func fromSignInResponse(_ dto: SignInResponseDTO) -> User? {
        return User(fromDTO: dto)
    }
    
    static func fromSignInResponse(_ dto: SignInResponseDTO, fetchUserData: Bool = true) async throws -> User {
        let user = User(fromDTO: dto)
        
        if fetchUserData {
            // Burada ek user verilerini API'den çekebilirsin
            // user = try await UserService.shared.fetchCompleteUserData(for: user.id)
        }
        
        return user
    }
    
    // Helper methods
    private static func parseDate(from dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        
        // Firebase timestamp formatını parse et
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString)
    }
    
    private static func generateReferralCode(from input: String) -> String {
        let cleanInput = input.uppercased().replacingOccurrences(of: " ", with: "")
        let prefix = String(cleanInput.prefix(4)).padding(toLength: 4, withPad: "X", startingAt: 0)
        let randomSuffix = String(Int.random(in: 1000...9999))
        return prefix + randomSuffix
    }
}
