//
//  Delivery.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/6/25.
//

import Foundation
import FirebaseFirestore

struct Delivery: Identifiable, Codable, Equatable {
    let id: String
    let orderNumber: String
    let customer: Customer
    let items: [DeliveryItem]
    var status: DeliveryStatus
    let createdAt: Date
    let scheduledDeliveryDate: Date
    var actualDeliveryDate: Date?
    let totalAmount: Double
    let deliveryFee: Double
    let specialInstructions: String?
    var driverNotes: String?
    var currentLocation: GeoPoint?
    
    init(id: String = UUID().uuidString,
         orderNumber: String,
         customer: Customer,
         items: [DeliveryItem],
         status: DeliveryStatus = .pending,
         createdAt: Date = Date(),
         scheduledDeliveryDate: Date,
         deliveryFee: Double = 10.0,
         specialInstructions: String? = nil) {
        self.id = id
        self.orderNumber = orderNumber
        self.customer = customer
        self.items = items
        self.status = status
        self.createdAt = createdAt
        self.scheduledDeliveryDate = scheduledDeliveryDate
        self.totalAmount = items.reduce(0) { $0 + $1.totalPrice }
        self.deliveryFee = deliveryFee
        self.specialInstructions = specialInstructions
    }
}
