//
//  CartItem.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation
import Combine

class CartViewModel: ObservableObject {
    
    @Published var isExpanded = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isProcessingOrder: Bool = false
    @Published var showOrderConfirmation = false
    @Published var selectedAddress: Address?
    @Published var showAddressForm = false
    @Published var closeSheet = false
    
    @Published var selectedPaymentMethod: PaymentMethod.PaymentType = .card

    @Published var items: [CartItem] = []
    
    private var cancellables: Set<AnyCancellable> = []
    @Injected private var createOrderUseCase: CreateOrderUseCaseProtocol
    
    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    var totalSavings: Double {
        items.reduce(0) { total, item in
//            if let originalPrice = item.product.originalPrice {
//                return total + (originalPrice - item.product.price) * Double(item.quantity)
//            }
            return total
        }
    }
    
    func addItem(product: Product, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product.title == product.title }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
    }
    
    func updateQuantity(for item: CartItem, quantity: Int) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            if quantity > 0 {
                items[index].quantity = quantity
            } else {
                items.remove(at: index)
            }
        }
    }
    
    func removeItem(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
    }
    
    func clearCart() {
        items.removeAll()
    }
    
    func createOrder(order: Order, onSucces: @escaping () -> Void){
        isProcessingOrder = true
        createOrderUseCase.execute(order: order)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                
            } receiveValue: { [weak self] documentId in
                print("\(documentId)")
                self?.items.removeAll()
                self?.isProcessingOrder = false
                self?.showOrderConfirmation = true
                onSucces()
            }
            .store(in: &cancellables)
    }
}

