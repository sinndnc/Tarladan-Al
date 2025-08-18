//
//  OrderCard.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/18/25.
//
import SwiftUI

// MARK: - Order Card
struct OrderCard: View {
    let order: Order
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(order.orderNumber)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(order.orderDate, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: order.status.icon)
                                .foregroundColor(order.status.color)
                                .font(.caption)
                            
                            Text(order.status.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(order.status.color)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(order.status.color.opacity(0.1))
                        .cornerRadius(8)
                        
                        Text("₺\(order.totalAmount, specifier: "%.2f")")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                }
                
                // Ürün Önizleme
                HStack(spacing: 8) {
                    ForEach(Array(order.items.prefix(3)), id: \.id) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            // Ürün görseli placeholder
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    VStack {
                                        Image(systemName: item.product.isOrganic ? "leaf.fill" : "photo")
                                            .foregroundColor(item.product.isOrganic ? .green : .gray)
                                            .font(.caption)
                                    }
                                )
                            
                            Text(item.product.title)
                                .font(.caption)
                                .lineLimit(2)
                                .frame(width: 50, alignment: .leading)
                        }
                    }
                    
                    if order.items.count > 3 {
                        VStack {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Text("+\(order.items.count - 3)")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.gray)
                                )
                            
                            Text("daha")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                
                // Alt Bilgiler
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Çiftçi: \(order.items.first?.product.farmerName ?? "")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if order.items.count > 1 {
                            Text("ve \(order.items.count - 1) çiftçi daha")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("\(Int(order.totalQuantity))")
                            .font(.caption)
                            .fontWeight(.medium)
                        Text("ürün")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Delivery Info
                if let deliveryDate = order.deliveryDate {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Text("Teslimat: \(deliveryDate, style: .date)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("• \(order.deliveryAddress.district), \(order.deliveryAddress.city)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
