//
//  DeliveryDTO.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/6/25.
//
import Foundation
import FirebaseCore
import FirebaseFirestore

struct DeliveryDTO: Codable {
    @DocumentID var id: String?
    let orderNumber: String
    let customerId: String
    let customerName: String
    let customerEmail: String
    let customerPhone: String
    let deliveryAddress: DeliveryAddress
    let items: [DeliveryItemDTO]
    let status: String
    let createdAt: Timestamp
    let scheduledDeliveryDate: Timestamp
    let actualDeliveryDate: Timestamp?
    let totalAmount: Double
    let deliveryFee: Double
    let specialInstructions: String?
    let driverNotes: String?
    let currentLatitude: Double?
    let currentLongitude: Double?
}
