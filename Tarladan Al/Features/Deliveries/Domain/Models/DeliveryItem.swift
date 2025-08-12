//
//  DeliveryItem.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/6/25.
//

import Foundation

struct DeliveryItem: Identifiable, Codable, Equatable ,Hashable {
    let id: String
    let productName: String
    let productId: String
    let quantity: Double
    let unit: String
    let pricePerUnit: Double
    let totalPrice: Double
    let isTemperatureSensitive: Bool
    let requiredTemperature: Double?
    
    init(id: String = UUID().uuidString,
         productName: String,
         productId: String,
         quantity: Double,
         unit: String,
         pricePerUnit: Double,
         isTemperatureSensitive: Bool = false,
         requiredTemperature: Double? = nil) {
        self.id = id
        self.productName = productName
        self.productId = productId
        self.quantity = quantity
        self.unit = unit
        self.pricePerUnit = pricePerUnit
        self.totalPrice = quantity * pricePerUnit
        self.isTemperatureSensitive = isTemperatureSensitive
        self.requiredTemperature = requiredTemperature
    }
}
