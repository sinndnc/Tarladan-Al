//
//  UserDTO.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/22/25.
//

import Foundation
import FirebaseFirestore

struct UserDTO : FirebaseModel{
    var id: String?
    let email: String
    var phone: String
    let lastName: String
    let firstName: String
    let profileImageUrl: String?
    
    var isActive: Bool
    var isVerified: Bool
    var phoneVerified: Bool
    let emailVerified: Bool
    
    let createdAt: Date
    var updatedAt: Date
    var lastLogin: Date?
    
    var language: String
    var currency: String
    var timeZone: String
    var newsletterOptIn: Bool
    var smsOptIn: Bool
    
    var reviews: [String] = []
    var favorites: [String] = []
    var addresses: [Address] = []
    var paymentMethods: [PaymentMethod] = []
    var subscription: Subscription?
    
    var dietaryPrefs: DietaryPreference = DietaryPreference()
    
    var customerNotes: String
    var loyaltyPoints: Int
    var referralCode: String
    
    var totalOrders: Int
    var totalSpent: Double
    var averageOrder: Double
    var lastOrderDate: Date?
    
    var utmSource: String?
    var utmCampaign: String?
    var referredBy: Int?
    
    enum CodingKeys: String, CodingKey {
        case email, phone, language, currency, referralCode
        case firstName = "first_name"
        case lastName = "last_name"
        case isActive = "is_active"
        case isVerified = "is_verified"
        case emailVerified = "email_verified"
        case profileImageUrl = "profile_image_url"
        case phoneVerified = "phone_verified"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case lastLogin = "last_login"
        case timeZone = "timezone"
        case newsletterOptIn = "newsletter_opt_in"
        case smsOptIn = "sms_opt_in"
        case addresses, paymentMethods, subscription, favorites, reviews
        case dietaryPrefs = "dietary_preferences"
        case customerNotes = "customer_notes"
        case loyaltyPoints = "loyalty_points"
        case utmSource = "utm_source"
        case utmCampaign = "utm_campaign"
        case referredBy = "referred_by"
        case totalOrders = "total_orders"
        case totalSpent = "total_spent"
        case averageOrder = "average_order"
        case lastOrderDate = "last_order_date"
    }
}
