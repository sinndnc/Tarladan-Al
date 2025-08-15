//
//  CartView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/12/25.
//

import SwiftUI

struct CartView: View {
    
    @State private var showCheckout = false
    @State private var showClearAlert = false
    
    @EnvironmentObject private var cartViewModel : CartViewModel
    
    var body: some View {
        NavigationStack {
            ZStack{
                if cartViewModel.items.isEmpty {
                    emptyCartView
                } else {
                    VStack(spacing: 0) {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(cartViewModel.items) { item in
                                    CartItemRow(
                                        item: item,
                                        onQuantityChange: { newQuantity in
                                            cartViewModel.updateQuantity(for: item, quantity: newQuantity)
                                        },
                                        onRemove: {
                                            withAnimation(.easeInOut) {
                                                cartViewModel.removeItem(item)
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 16)
                        }
                        
                        // Cart Summary
                        cartSummaryView
                    }
                }
            }
            .navigationTitle("Shopping Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !cartViewModel.items.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear") {
                            showClearAlert = true
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .alert("Clear Cart", isPresented: $showClearAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    withAnimation(.easeInOut) {
                        cartViewModel.clearCart()
                    }
                }
            } message: {
                Text("Are you sure you want to remove all items from your cart?")
            }
            .sheet(isPresented: $showCheckout) {
                CheckoutView(cartViewModel: cartViewModel)
            }
        }
    }
    
    private var emptyCartView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "cart")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("Your cart is empty")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Add some products to get started")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Button("Continue Shopping") {
                // Navigate to products
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(Color.blue)
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
    }
    
    private var cartSummaryView: some View {
        VStack(spacing: 16) {
            Divider()
            
            VStack(spacing: 12) {
                HStack {
                    Text("Subtotal (\(cartViewModel.totalItems) items)")
                        .font(.subheadline)
                    Spacer()
                    Text("₺\(cartViewModel.totalPrice, specifier: "%.2f")")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                if cartViewModel.totalSavings > 0 {
                    HStack {
                        Text("Savings")
                            .font(.subheadline)
                            .foregroundColor(.green)
                        Spacer()
                        Text("-₺\(cartViewModel.totalSavings, specifier: "%.2f")")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.green)
                    }
                }
                
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Text("₺\(cartViewModel.totalPrice, specifier: "%.2f")")
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal)
            
            Button("Proceed to Checkout") {
                showCheckout = true
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
    }
}


struct CartItemRow: View {
    let item: CartItem
    let onQuantityChange: (Int) -> Void
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
//            // Product Image
//            AsyncImage(url: URL(string: item.product.image)) { image in
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//            } placeholder: {
//                Rectangle()
//                    .fill(Color.gray.opacity(0.3))
//                    .overlay(
//                        Image(systemName: "photo")
//                            .foregroundColor(.gray)
//                    )
//            }
//            .frame(width: 80, height: 80)
//            .cornerRadius(8)
            
            // Product Details
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(item.product.category?.name ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    if item.product.isOrganic {
                        HStack(spacing: 2) {
                            Image(systemName: "leaf.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                            Text("Organic")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                    
                    if item.product.isOrganic {
                        Text("SALE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(3)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("₺\(item.product.price, specifier: "%.2f")")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
//                        if let originalPrice = item.product.originalPrice {
//                            Text("₺\(originalPrice, specifier: "%.2f")")
//                                .font(.caption)
//                                .strikethrough()
//                                .foregroundColor(.secondary)
//                        }
                    }
                    
                    Spacer()
                    
                    Text("₺\(item.totalPrice, specifier: "%.2f")")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            // Quantity Controls
            VStack(spacing: 12) {
                Button(action: onRemove) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                
                VStack(spacing: 8) {
                    Button("+") {
                        onQuantityChange(item.quantity + 1)
                    }
                    .frame(width: 32, height: 32)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                    
                    Text("\(item.quantity)")
                        .font(.headline)
                        .frame(minWidth: 24)
                    
                    Button("-") {
                        if item.quantity > 1 {
                            onQuantityChange(item.quantity - 1)
                        }
                    }
                    .frame(width: 32, height: 32)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
                    .disabled(item.quantity <= 1)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct CheckoutView: View {
    @ObservedObject var cartViewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Checkout functionality would go here")
                    .font(.headline)
                    .padding()
                
                Button("Complete Order") {
                    // Order completion logic
                    cartViewModel.clearCart()
                    dismiss()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(12)
                .padding()
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

