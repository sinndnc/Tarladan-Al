//
//  ProductGridCard.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/22/25.
//
import SwiftUI

struct ProductGridCard: View {
    let product: Product
    let onTap: () -> Void
    
    @State private var showingAddedToCart = false
    @EnvironmentObject private var userViewModel: UserViewModel
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Product Image
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 120)
                        .overlay(
                            VStack {
                                if product.isOrganic {
                                    Image(systemName: "leaf.fill")
                                        .foregroundColor(.green)
                                        .font(.title)
                                } else {
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                        .font(.title)
                                }
                            }
                        )
                    
                    // Favorite Button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
//                            viewModel.toggleFavorite(product)
                        }
                    }) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                            .padding(8)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                    }
                    .padding(8)
                }
                
                // Product Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                    
                    Text(product.farmerName)
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text(product.locationName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
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
                        
                        Spacer()
                        
                        Text("₺\(product.price, specifier: "%.0f")/\(product.unit)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                }
                
                // Add to Cart Button
                Button(action: addToCart) {
                    HStack {
                        Image(systemName: showingAddedToCart ? "checkmark" : "cart.badge.plus")
                            .font(.caption)
                        
                        Text(showingAddedToCart ? "Eklendi" : "Sepete Ekle")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(showingAddedToCart ? Color.green : Color.blue)
                    .cornerRadius(8)
                }
                .disabled(showingAddedToCart)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingAddedToCart = false
            }
        }
    }
}
