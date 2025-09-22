//
//  ShelfLifeCategory.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/17/25.
//

import SwiftUI

enum ShelfLifeCategory {
    case veryShort, short, medium, long, veryLong
    
    var color: Color {
        switch self {
        case .veryShort: return .red
        case .short: return .orange
        case .medium: return .yellow
        case .long: return .green
        case .veryLong: return .blue
        }
    }
    
    var text: String {
        switch self {
        case .veryShort: return "Çok kısa"
        case .short: return "Kısa"
        case .medium: return "Orta"
        case .long: return "Uzun"
        case .veryLong: return "Çok uzun"
        }
    }
}
