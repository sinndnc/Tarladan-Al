//
//  DeliveryStatus.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/6/25.
//

import SwiftUICore

enum DeliveryStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case confirmed = "confirmed"
    case preparing = "preparing"
    case inTransit = "in_transit"
    case delivered = "delivered"
    case cancelled = "cancelled"
    
    var displayName: String {
        switch self {
        case .pending: return "Beklemede"
        case .confirmed: return "Onaylandı"
        case .preparing: return "Hazırlanıyor"
        case .inTransit: return "Yolda"
        case .delivered: return "Teslim Edildi"
        case .cancelled: return "İptal Edildi"
        }
    }
    
    var progressValue: Double {
        switch self {
        case .preparing: return 0.6
        case .inTransit: return 0.8
        case .delivered: return 1.0
        case .cancelled: return 0.0
        case .pending: return 0.2
        case .confirmed: return 0.4
        }
    }
    
    var icon: String {
        switch self {
        case .preparing: return "clock.fill"
        case .inTransit: return "truck.box.fill"
        case .delivered: return "checkmark.circle.fill"
        case .cancelled: return "xmark.circle.fill"
        case .confirmed: return "exclamationmark.triangle.fill"
        case .pending: return "questionmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .pending: return .orange
        case .confirmed: return .blue
        case .preparing: return .yellow
        case .inTransit: return .purple
        case .delivered: return .green
        case .cancelled: return .red
        }
    }
}
