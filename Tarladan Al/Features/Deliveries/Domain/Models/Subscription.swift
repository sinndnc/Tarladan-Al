//
//  Subscription.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//

import Foundation


struct Subscription: Codable, Identifiable, Hashable {
    let id: Int
    var boxSize: BoxSize
    var frequency: DeliveryFrequency
    var deliveryDay: DeliveryDay
    var isActive: Bool
    var nextDelivery: Date
    var pausedUntil: Date?
    var customProducts: [Int] // Product IDs for customization
    
    enum BoxSize: String, Codable, CaseIterable {
        case small = "small"
        case medium = "medium"
        case large = "large"
        
        var displayName: String {
            switch self {
            case .small: return "Small Box"
            case .medium: return "Medium Box"
            case .large: return "Large Box"
            }
        }
    }
    
    enum DeliveryFrequency: String, Codable, CaseIterable {
        case weekly = "weekly"
        case biWeekly = "bi-weekly"
        case monthly = "monthly"
        
        var displayName: String {
            switch self {
            case .weekly: return "Weekly"
            case .biWeekly: return "Bi-weekly"
            case .monthly: return "Monthly"
            }
        }
    }
    
    enum DeliveryDay: String, Codable, CaseIterable {
        case monday = "monday"
        case tuesday = "tuesday"
        case wednesday = "wednesday"
        case thursday = "thursday"
        case friday = "friday"
        case saturday = "saturday"
        
        var displayName: String {
            rawValue.capitalized
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, frequency, isActive, customProducts
        case boxSize = "box_size"
        case deliveryDay = "delivery_day"
        case nextDelivery = "next_delivery"
        case pausedUntil = "paused_until"
    }
}
