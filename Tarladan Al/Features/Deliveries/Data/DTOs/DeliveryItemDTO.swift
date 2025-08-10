//
//  DeliveryItemDTO.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/6/25.
//

import Foundation

struct DeliveryItemDTO: Codable {
    let id: String
    let productName: String
    let productId: String
    let quantity: Double
    let unit: String
    let pricePerUnit: Double
    let totalPrice: Double
    let isTemperatureSensitive: Bool
    let requiredTemperature: Double?
}
