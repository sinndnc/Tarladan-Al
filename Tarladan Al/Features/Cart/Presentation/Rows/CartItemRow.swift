//
//  CartItemRow.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/17/25.
//
import SwiftUI

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
                        }else{
                            onRemove()
                        }
                    }
                    .frame(width: 32, height: 32)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
