//
//  OrderStatus.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/18/25.
//

import SwiftUICore

enum OrderStatus: String, Codable,CaseIterable {
    case pending = "Hazırlanıyor"
    case confirmed = "Onaylandı"
    case shipping = "Kargoda"
    case delivered = "Teslim Edildi"
    case cancelled = "İptal Edildi"
    
    var color: Color {
        switch self {
        case .pending: return .orange
        case .confirmed: return .blue
        case .shipping: return .purple
        case .delivered: return .green
        case .cancelled: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .pending: return "clock.fill"
        case .confirmed: return "checkmark.circle.fill"
        case .shipping: return "truck.box.fill"
        case .delivered: return "checkmark.seal.fill"
        case .cancelled: return "xmark.circle.fill"
        }
    }
}
