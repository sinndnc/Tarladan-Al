//
//  CartView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/12/25.
//

import SwiftUI
struct CartView: View {
    
    @State private var showClearAlert = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var cartViewModel: CartViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if cartViewModel.items.isEmpty {
                    emptyCartView
                } else {
                    VStack(spacing: 0) {
                        // Cart Items
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(cartViewModel.items) { item in
                                    CartItemRow(
                                        item: item,
                                        onQuantityChange: { newQuantity in
                                            cartViewModel.updateQuantity(for: item, quantity: newQuantity)
                                        },
                                        onRemove: {
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                                cartViewModel.removeItem(item)
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            .padding(.bottom, 120)
                        }
                        .scrollIndicators(.hidden)
                    }
                    
                    // Floating Cart Summary
                    VStack {
                        Spacer()
                        cartSummaryView
                    }
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                            .frame(width: 32, height: 32)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                }
                
                if !cartViewModel.items.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showClearAlert = true
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.red)
                                .frame(width: 32, height: 32)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                    }
                }
            }
            .alert("Clear Cart", isPresented: $showClearAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        cartViewModel.clearCart()
                    }
                }
            } message: {
                Text("This will remove all items from your cart")
            }
        }
    }
    
    private var emptyCartView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon with subtle animation
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "cart")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 12) {
                Text("Your cart is empty")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Discover amazing products and\nadd them to your cart")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 8) {
                    Text("Start Shopping")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [.blue, .blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .blue.opacity(0.3), radius: 8, y: 4)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    private var cartSummaryView: some View {
        VStack(spacing: 0) {
            // Summary Card
            VStack(spacing: 16) {
                // Order Summary
                VStack(spacing: 12) {
                    HStack {
                        Text("Items (\(cartViewModel.totalItems))")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("₺\(cartViewModel.totalPrice, specifier: "%.2f")")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    
                    if cartViewModel.totalSavings > 0 {
                        HStack {
                            Text("Savings")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.green)
                            Spacer()
                            Text("-₺\(cartViewModel.totalSavings, specifier: "%.2f")")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.green)
                        }
                    }
                    
                    Divider()
                        .background(.quaternary)
                    
                    HStack {
                        Text("Total")
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                        Text("₺\(cartViewModel.totalPrice, specifier: "%.2f")")
                            .font(.system(size: 18, weight: .bold))
                    }
                }
                .padding(20)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                
                // Checkout Button
                NavigationLink {
                    CheckOutView()
                } label: {
                    HStack(spacing: 8) {
                        Text("Proceed to Checkout")
                            .font(.system(size: 17, weight: .semibold))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [.black, .black.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                }
            }
            .padding(20)
            .background(.thinMaterial)
        }
        .background(.clear)
    }
}
