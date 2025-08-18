//
//  ProductSubCategory.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//

import Foundation

struct ProductSubCategory: Identifiable, Codable, Hashable {
    var id = UUID()
    let name: String
    let icon: String
    let defaultUnit: MeasurementUnit
    let alternativeUnits: [MeasurementUnit]
    let seasonalityMonths: [Int] // 1-12 arası aylar
    let storageType: StorageType
    let shelfLife: Int // gün cinsinden
    let variants: [String] // çeşitler
    let keywords: [String] // arama için
    
    // Computed properties
    var isInSeason: Bool {
        let currentMonth = Calendar.current.component(.month, from: Date())
        return seasonalityMonths.contains(currentMonth)
    }
    
    var seasonDisplayText: String {
        if seasonalityMonths.isEmpty { return "Tüm yıl" }
        if seasonalityMonths.count == 12 { return "Tüm yıl" }
        
        let monthNames = ["", "Oca", "Şub", "Mar", "Nis", "May", "Haz",
                         "Tem", "Ağu", "Eyl", "Eki", "Kas", "Ara"]
        let seasonMonths = seasonalityMonths.compactMap { monthNames[$0] }
        
        if seasonMonths.count <= 3 {
            return seasonMonths.joined(separator: ", ")
        } else {
            return "\(seasonMonths.first ?? "") - \(seasonMonths.last ?? "")"
        }
    }
    
    var shelfLifeCategory: ShelfLifeCategory {
        switch shelfLife {
        case 0...3: return .veryShort
        case 4...7: return .short
        case 8...30: return .medium
        case 31...90: return .long
        default: return .veryLong
        }
    }
}
