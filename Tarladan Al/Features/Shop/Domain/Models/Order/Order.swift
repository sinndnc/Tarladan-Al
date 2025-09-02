//
//  Order.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/18/25.
//
import Foundation
import FirebaseFirestore

struct Order : FirebaseModel {
    @DocumentID var id: String?
    let orderDate: Date
    let owner_id: String
    let items: [OrderItem]
    let orderNumber: String
    let status: OrderStatus
    let deliveryDate: Date?
    let totalAmount: Double
    let shippingCost: Double
    let deliveryAddress: Address
    
    var itemCount: Int {
        items.count
    }
    
    var totalQuantity: Double {
        items.reduce(0) { $0 + $1.quantity }
    }
}
