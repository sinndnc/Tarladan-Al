//
//  ProductSubCategory.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//

import Foundation

struct ProductSubCategory: Identifiable, Codable , Hashable{
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
}
