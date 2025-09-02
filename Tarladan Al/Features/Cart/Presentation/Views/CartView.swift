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
    
    @Environment(\.dismiss) private var dismiss
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
            .background(Colors.System.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
            .toolbarBackground(Colors.UI.tabBackground, for: .navigationBar)
            .toolbar {
                if !cartViewModel.items.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear") {
                            showClearAlert = true
                        }
                        .foregroundColor(.red)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        dismiss()
                    }label: {
                        HStack{
                            Image(systemName: "chevron.left")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("Shop")
                            .font(.subheadline)
                        }
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
                CheckOutView()
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
                dismiss()
                // Navigate to products
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(Colors.System.primary)
            .cornerRadius(12)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    private var cartSummaryView: some View {
        VStack(spacing: 16) {
            Divider()
            
            VStack(spacing: 12) {
                HStack {
                    Text("Subtotal (\(cartViewModel.totalItems) items)")
                        .font(.subheadline)
                        .foregroundStyle(Colors.System.surface)
                    Spacer()
                    Text("₺\(cartViewModel.totalPrice, specifier: "%.2f")")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Colors.System.surface)
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
                        .foregroundStyle(Colors.System.surface)
                    Spacer()
                    Text("₺\(cartViewModel.totalPrice, specifier: "%.2f")")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Colors.System.surface)
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
            .background(Colors.System.secondary)
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Colors.UI.tabBackground)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
    }
}
