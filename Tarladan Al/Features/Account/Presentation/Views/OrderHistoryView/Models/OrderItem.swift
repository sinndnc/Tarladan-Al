//
//  OrderItem.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/18/25.
//
import Foundation

struct OrderItem: FirebaseModel, Hashable {
    var id: String?
    let product: Product
    let quantity: Double
    let unitPrice: Double
    
    var totalPrice: Double {
        quantity * unitPrice
    }
}
