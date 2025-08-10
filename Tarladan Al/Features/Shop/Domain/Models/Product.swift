//
//  Product.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import Foundation


struct Product: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let category: String
    let price: Double
    let originalPrice: Double?
    let image: String
    let isOrganic: Bool
    let description: String
    let rating: Double
    let reviewCount: Int
    let isOnSale: Bool
    let stockStatus: StockStatus
    let seasonality: String?
    let nutritionHighlights: [String]
    let origin: String
}
