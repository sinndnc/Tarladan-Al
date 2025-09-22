//
//  StockStatus.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import SwiftUI

enum StockStatus {
    case inStock
    case lowStock
    case outOfStock
    
    var color: Color {
        switch self {
        case .inStock: return .green
        case .lowStock: return .orange
        case .outOfStock: return .red
        }
    }
    
    var text: String {
        switch self {
        case .inStock: return "Stokta"
        case .lowStock: return "Az Stok"
        case .outOfStock: return "Tükendi"
        }
    }
}
