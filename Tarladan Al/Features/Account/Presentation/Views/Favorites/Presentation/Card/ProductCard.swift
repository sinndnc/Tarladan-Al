//
//  ProductListCard.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/19/25.
//
import SwiftUI

struct ProductCard: View {
    let product: Product
    let onTap: () -> Void
    
    @State private var showingAddedToCart = false
    @EnvironmentObject private var userViewModel: UserViewModel
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Product Image
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .overlay(
                            VStack {
                                if product.isOrganic {
                                    Image(systemName: "leaf.fill")
                                        .foregroundColor(.green)
                                        .font(.title2)
                                } else {
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                        .font(.title2)
                                }
                            }
                        )
                }
                
                // Product Details
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(product.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
//                                viewModel.toggleFavorite(product)
                            }
                        }) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .font(.title3)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Text(product.farmerName)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.gray)
                            .font(.caption)
                        
                        Text(product.locationName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if product.isOrganic {
                            HStack(spacing: 2) {
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(.green)
                                    .font(.caption)
                                Text("Organik")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    HStack {
                        Text("₺\(product.price, specifier: "%.0f")/\(product.unit)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("• \(product.quantity, specifier: "%.0f") \(product.unit) stok")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button(action: addToCart) {
                            Image(systemName: showingAddedToCart ? "checkmark.circle.fill" : "cart.badge.plus")
                                .foregroundColor(showingAddedToCart ? .green : .blue)
                                .font(.title2)
                        }
                        .disabled(showingAddedToCart)
                    }
                }
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    private func addToCart() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showingAddedToCart = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingAddedToCart = false
            }
        }
    }
}
