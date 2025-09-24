//
//  CartItem.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/17/25.
//

import SwiftUI
struct CheckOutView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var shopViewModel: ShopViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    
    @State private var showOrderSuccess = false
    
    private var shippingCost: Double {
        cartViewModel.totalPrice > 50000 ? 0 : 49.99
    }
    
    private var tax: Double {
        cartViewModel.totalPrice * 0.18
    }
    
    private var total: Double {
        cartViewModel.totalPrice + shippingCost + tax
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 24) {
                    orderSummaryCard
                    deliveryAddressCard
                    paymentMethodCard
                    pricingBreakdownCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 120)
            }
            .scrollIndicators(.hidden)
            
            // Floating Checkout Button
            VStack {
                Spacer()
                checkoutButton
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.large)
        .alert("Order Confirmed!", isPresented: $showOrderSuccess) {
            Button("Continue Shopping") {
                shopViewModel.showCart = false
                dismiss()
            }
        } message: {
            Text("Your order has been successfully placed. Tracking information will be sent to your email.")
        }
    }
    
    // MARK: - Order Summary Card
    private var orderSummaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "bag")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.blue)
                
                Text("Order Summary")
                    .font(.system(size: 20, weight: .semibold))
                
                Spacer()
                
                Text("\(cartViewModel.items.count) items")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 12) {
                ForEach(cartViewModel.items) { item in
                    HStack(spacing: 12) {
                        // Product Image Placeholder
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.quaternary)
                            .frame(width: 56, height: 56)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 20))
                                    .foregroundColor(.secondary)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.product.title)
                                .font(.system(size: 15, weight: .medium))
                                .lineLimit(2)
                            
                            HStack {
                                Text("Qty: \(item.quantity)")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("₺\(item.totalPrice, specifier: "%.2f")")
                                    .font(.system(size: 15, weight: .semibold))
                            }
                        }
                        
                        Spacer()
                    }
                    
                    if item.id != cartViewModel.items.last?.id {
                        Divider()
                            .background(.quaternary)
                    }
                }
            }
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    // MARK: - Delivery Address Card
    private var deliveryAddressCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "location")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.green)
                
                Text("Delivery Address")
                    .font(.system(size: 20, weight: .semibold))
                
                Spacer()
            }
            
            if let user = userViewModel.user,
               let defaultAddress = user.defaultAddress {
                
                // Selected Address
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(defaultAddress.title)
                                    .font(.system(size: 16, weight: .semibold))
                                
                                if defaultAddress.isDefault {
                                    Text("Default")
                                        .font(.system(size: 11, weight: .medium))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(.green.opacity(0.15))
                                        .foregroundColor(.green)
                                        .cornerRadius(8)
                                }
                                
                                Spacer()
                            }
                            
                            Text(defaultAddress.fullAddress)
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                                .lineLimit(2)
                            
                            Text("\(defaultAddress.district), \(defaultAddress.city)")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.green)
                    }
                    .padding(16)
                    .background(.green.opacity(0.08))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.green.opacity(0.2), lineWidth: 1)
                    )
                }
                
                // Other Addresses
                if user.addresses.count > 1 {
                    VStack(spacing: 8) {
                        ForEach(user.addresses.filter { !$0.isDefault }) { address in
                            addressOptionRow(address)
                        }
                    }
                }
                
                // Add New Address Button
                Button {
                    cartViewModel.showAddressForm = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Add New Address")
                            .font(.system(size: 15, weight: .medium))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(.blue)
                    .padding(16)
                    .background(.blue.opacity(0.06))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.blue.opacity(0.2), lineWidth: 1)
                    )
                }
            }
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    // MARK: - Address Option Row
    private func addressOptionRow(_ address: Address) -> some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                // Change default address logic
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(address.title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text("\(address.district), \(address.city)")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "circle")
                    .font(.system(size: 20))
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(.quaternary.opacity(0.3))
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Payment Method Card
    private var paymentMethodCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "creditcard")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.orange)
                
                Text("Payment Method")
                    .font(.system(size: 20, weight: .semibold))
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(PaymentMethod.PaymentType.allCases, id: \.self) { method in
                    Button {
                        withAnimation(.easeOut(duration: 0.2)) {
                            cartViewModel.selectedPaymentMethod = method
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: cartViewModel.selectedPaymentMethod == method ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 20))
                                .foregroundColor(cartViewModel.selectedPaymentMethod == method ? .blue : .secondary)
                            
                            Text(method.rawValue)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: paymentMethodIcon(for: method))
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                        }
                        .padding(16)
                        .background(
                            cartViewModel.selectedPaymentMethod == method ?
                                .blue.opacity(0.08) : .secondary.opacity(0.3)
                        )
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    cartViewModel.selectedPaymentMethod == method ?
                                        .blue.opacity(0.3) : .clear,
                                    lineWidth: 1
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    // MARK: - Pricing Breakdown Card
    private var pricingBreakdownCard: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                HStack {
                    Text("Subtotal")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("₺\(cartViewModel.totalPrice, specifier: "%.2f")")
                        .font(.system(size: 15, weight: .medium))
                }
                
                HStack {
                    Text("Shipping")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                    Spacer()
                    if shippingCost == 0 {
                        Text("Free")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.green)
                    } else {
                        Text("₺\(shippingCost, specifier: "%.2f")")
                            .font(.system(size: 15, weight: .medium))
                    }
                }
                
                HStack {
                    Text("Tax (18%)")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("₺\(tax, specifier: "%.2f")")
                        .font(.system(size: 15, weight: .medium))
                }
                
                if cartViewModel.totalSavings > 0 {
                    HStack {
                        Text("Savings")
                            .font(.system(size: 15))
                            .foregroundColor(.green)
                        Spacer()
                        Text("-₺\(cartViewModel.totalSavings, specifier: "%.2f")")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
            }
            
            Divider()
                .background(.quaternary)
            
            HStack {
                Text("Total")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                Text("₺\(total, specifier: "%.2f")")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.blue)
            }
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    // MARK: - Checkout Button
    private var checkoutButton: some View {
        VStack(spacing: 0) {
            Button {
                let newOrder = Order(
                    orderDate: Date(),
                    owner_id: userViewModel.user?.id ?? "",
                    items: cartViewModel.items.map { item in
                        OrderItem(
                            product: item.product,
                            quantity: Double(item.quantity),
                            unitPrice: item.totalPrice
                        )
                    },
                    orderNumber: UUID().uuidString,
                    status: .pending,
                    deliveryDate: Date(),
                    totalAmount: total,
                    shippingCost: shippingCost,
                    deliveryAddress: userViewModel.user!.defaultAddress!
                )
                
                cartViewModel.createOrder(order: newOrder) {
                    showOrderSuccess = true
                }
                
            } label: {
                HStack(spacing: 12) {
                    if cartViewModel.isProcessingOrder {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.9)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18, weight: .medium))
                    }
                    
                    Text(cartViewModel.isProcessingOrder ? "Processing..." : "Complete Order")
                        .font(.system(size: 17, weight: .semibold))
                    
                    if !cartViewModel.isProcessingOrder {
                        Text("₺\(total, specifier: "%.2f")")
                            .font(.system(size: 15, weight: .medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(.white.opacity(0.2))
                            .cornerRadius(12)
                    }
                }
                .foregroundColor(.white)
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: cartViewModel.isProcessingOrder ?
                            [.gray, .gray.opacity(0.8)] :
                            [.black, .black.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
            }
            .disabled(cartViewModel.isProcessingOrder)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .background(.thinMaterial)
        }
    }
    
    // MARK: - Helper Functions
    private func paymentMethodIcon(for method: PaymentMethod.PaymentType) -> String {
        switch method {
        case .card:
            return "creditcard"
        case .paypal:
            return "apple.logo"
        case .bankTransfer:
            return "banknote"
        }
    }
}
