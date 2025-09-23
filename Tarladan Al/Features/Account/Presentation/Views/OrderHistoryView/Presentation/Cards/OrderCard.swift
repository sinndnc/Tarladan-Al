//
//  OrderCard.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/18/25.
//
import SwiftUI
struct OrderCard: View {
    let order: Order
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                // Header Section
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(order.orderNumber)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(order.orderDate, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 8) {
                        // Status Badge
                        HStack(spacing: 6) {
                            Circle()
                                .fill(order.status.color)
                                .frame(width: 8, height: 8)
                            
                            Text(order.status.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(order.status.color)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(order.status.color.opacity(0.1))
                        )
                        
                        // Total Amount
                        Text("₺\(order.totalAmount, specifier: "%.0f")")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                }
                
                // Product Preview Section
                HStack(spacing: 12) {
                    // Product Icons
                    HStack(spacing: -8) {
                        ForEach(Array(order.items.prefix(4)), id: \.id) { item in
                            Circle()
                                .fill(item.product.isOrganic ? .green.opacity(0.1) : .gray.opacity(0.1))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: item.product.isOrganic ? "leaf.fill" : "photo")
                                        .font(.caption)
                                        .foregroundColor(item.product.isOrganic ? .green : .gray)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color(.systemBackground), lineWidth: 2)
                                )
                        }
                        
                        if order.items.count > 4 {
                            Circle()
                                .fill(.gray.opacity(0.1))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Text("+\(order.items.count - 4)")
                                        .font(.caption2)
                                        .fontWeight(.medium)
                                        .foregroundColor(.gray)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color(.systemBackground), lineWidth: 2)
                                )
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(Int(order.totalQuantity)) ürün")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        if let firstFarmer = order.items.first?.product.farmerName {
                            let uniqueFarmers = Set(order.items.map { $0.product.farmerName })
                            if uniqueFarmers.count == 1 {
                                Text(firstFarmer)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("\(uniqueFarmers.count) farklı çiftçi")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Spacer()
                }
                
                // Delivery Information
                if let deliveryDate = order.deliveryDate {
                    HStack(spacing: 8) {
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Teslimat")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            HStack(spacing: 4) {
                                Text(deliveryDate, style: .date)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                
                                Text("•")
                                    .foregroundColor(.secondary)
                                
                                Text("\(order.deliveryAddress.district)")
                                    .font(.caption)
                            }
                            .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: .black.opacity(0.06),
                        radius: 12,
                        x: 0,
                        y: 4
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
