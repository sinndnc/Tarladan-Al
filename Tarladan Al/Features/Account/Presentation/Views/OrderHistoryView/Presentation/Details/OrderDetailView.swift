//
//  OrderDetailView 2.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/23/25.
//
import SwiftUI

// MARK: - Premium Order Detail View
struct OrderDetailView: View {
    let order: Order
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Order Header
                    orderHeaderSection
                    
                    // Status Progress
                    statusProgressSection
                    
                    // Order Items
                    orderItemsSection
                    
                    // Delivery Info
                    deliveryInfoSection
                    
                    // Price Summary
                    priceSummarySection
                }
                .padding(20)
            }
            .navigationTitle("Sipariş Detayları")
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var orderHeaderSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Sipariş")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .tracking(1)
                    
                    Text(order.orderNumber)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                Text("₺\(order.totalAmount, specifier: "%.0f")")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            HStack {
                Text(order.orderDate, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(order.status.color)
                        .frame(width: 8, height: 8)
                    
                    Text(order.status.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(order.status.color)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(order.status.color.opacity(0.1))
                .clipShape(Capsule())
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
    
    private var statusProgressSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Sipariş Takibi")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading,spacing: 10) {
                ForEach(Array(OrderStatus.allCases.enumerated()), id: \.element) { index, status in
                    let isCompleted = statusIndex(status) <= statusIndex(order.status)
                    let isCurrent = status == order.status
                    
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(isCompleted ? status.color : Color(.systemGray5))
                                .frame(width: 32, height: 32)
                            
                            if isCompleted {
                                Image(systemName: isCurrent ? status.icon : "checkmark")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            } else {
                                Circle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: 12, height: 12)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(status.rawValue)
                                .font(.subheadline)
                                .fontWeight(isCurrent ? .semibold : .medium)
                                .foregroundColor(isCompleted ? .primary : .secondary)
                            
                            if isCurrent, let deliveryDate = order.deliveryDate {
                                Text("Tahmini: \(deliveryDate, style: .date)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    if index < OrderStatus.allCases.count - 1 {
                        Rectangle()
                            .fill(isCompleted ? status.color.opacity(0.3) : Color(.systemGray5))
                            .frame(width: 2, height: 20)
                            .offset(x: 15)
                    }
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
    
    private var orderItemsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Ürünler")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(order.items.count) ürün")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ForEach(order.items, id: \.id) { item in
                HStack(spacing: 16) {
                    // Product Icon
                    Circle()
                        .fill(item.product.isOrganic ? .green.opacity(0.1) : .gray.opacity(0.1))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: item.product.isOrganic ? "leaf.fill" : "cart.fill")
                                .font(.title3)
                                .foregroundColor(item.product.isOrganic ? .green : .gray)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.product.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .lineLimit(2)
                        
                        Text(item.product.farmerName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 8) {
                            if item.product.isOrganic {
                                HStack(spacing: 4) {
                                    Image(systemName: "leaf.fill")
                                        .font(.caption2)
                                    Text("Organik")
                                        .font(.caption2)
                                }
                                .foregroundColor(.green)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.1))
                                .clipShape(Capsule())
                            }
                            
                            Text("\(item.quantity, specifier: "%.1f") \(item.product.unit)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("₺\(item.totalPrice, specifier: "%.0f")")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        Text("₺\(item.unitPrice, specifier: "%.0f")/\(item.product.unit)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
                
                if item.id != order.items.last?.id {
                    Divider()
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
    
    private var deliveryInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "location.circle.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
                
                Text("Teslimat Adresi")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(order.deliveryAddress.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(order.deliveryAddress.fullAddress)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(order.deliveryAddress.district), \(order.deliveryAddress.city)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 28)
            
            if let deliveryDate = order.deliveryDate {
                Divider()
                
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tahmini Teslimat")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(deliveryDate, style: .date)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
    
    private var priceSummarySection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Özet")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(spacing: 12) {
                HStack {
                    Text("Ürün Tutarı")
                        .font(.subheadline)
                    Spacer()
                    Text("₺\(order.totalAmount - order.shippingCost, specifier: "%.0f")")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                HStack {
                    Text("Kargo")
                        .font(.subheadline)
                    Spacer()
                    if order.shippingCost > 0 {
                        Text("₺\(order.shippingCost, specifier: "%.0f")")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    } else {
                        Text("Ücretsiz")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.green)
                    }
                }
                
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 1)
                
                HStack {
                    Text("Toplam")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    Text("₺\(order.totalAmount, specifier: "%.0f")")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
    
    private func statusIndex(_ status: OrderStatus) -> Int {
        OrderStatus.allCases.firstIndex(of: status) ?? 0
    }
}
