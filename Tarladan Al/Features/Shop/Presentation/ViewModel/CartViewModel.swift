//
//  CartItem.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation


@MainActor
class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var totalPrice: Double {
        items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var hasItems: Bool {
        !items.isEmpty
    }
    
    func addItem(_ product: Product, quantity: Int = 1) {
        if let existingIndex = items.firstIndex(where: { $0.product.id == product.id }) {
            items[existingIndex].quantity += quantity
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
    }
    
    func removeItem(_ product: Product) {
        items.removeAll { $0.product.id == product.id }
    }
    
    func updateQuantity(for product: Product, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            if quantity <= 0 {
                items.remove(at: index)
            } else {
                items[index].quantity = quantity
            }
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
}
