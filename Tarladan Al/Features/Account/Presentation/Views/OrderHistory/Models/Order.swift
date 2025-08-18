//
//  Order.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/18/25.
//
import Foundation

struct Order: Identifiable {
    let id = UUID()
    let orderNumber: String
    let items: [OrderItem]
    let orderDate: Date
    let deliveryDate: Date?
    let status: OrderStatus
    let deliveryAddress: Address
    let totalAmount: Double
    let shippingCost: Double
    
    var itemCount: Int {
        items.count
    }
    
    var totalQuantity: Double {
        items.reduce(0) { $0 + $1.quantity }
    }
}
