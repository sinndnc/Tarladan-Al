//
//  OrderDetailView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/18/25.
//
import SwiftUI
// MARK: - Order Detail View
struct OrderDetailView: View {
    let order: Order
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Order Header
                    orderHeaderSection
                    
                    // Status Timeline
                    statusTimelineSection
                    
                    // Items
                    orderItemsSection
                    
                    // Delivery Address
                    deliveryAddressSection
                    
                    // Price Breakdown
                    priceBreakdownSection
                }
                .padding()
            }
            .navigationTitle("Sipariş Detayı")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Kapat") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private var orderHeaderSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(order.orderNumber)
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Sipariş Tarihi: \(order.orderDate, style: .date)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: order.status.icon)
                    .foregroundColor(order.status.color)
                
                Text(order.status.rawValue)
                    .fontWeight(.medium)
                    .foregroundColor(order.status.color)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(order.status.color.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var statusTimelineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sipariş Durumu")
                .font(.headline)
            
            VStack(spacing: 16) {
                ForEach(OrderStatus.allCases, id: \.self) { status in
                    let isCompleted = statusIndex(status) <= statusIndex(order.status)
                    let isCurrent = status == order.status
                    
                    HStack {
                        Image(systemName: isCompleted ? status.icon : "circle")
                            .foregroundColor(isCompleted ? status.color : .gray)
                            .font(.title3)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(status.rawValue)
                                .fontWeight(isCurrent ? .semibold : .regular)
                                .foregroundColor(isCompleted ? .primary : .secondary)
                            
                            if isCurrent && order.deliveryDate != nil {
                                Text("Tahmini: \(order.deliveryDate!, style: .date)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var orderItemsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sipariş İçeriği")
                .font(.headline)
            
            ForEach(order.items) { item in
                HStack {
                    // Product Image Placeholder
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            VStack {
                                Image(systemName: item.product.isOrganic ? "leaf.fill" : "photo")
                                    .foregroundColor(item.product.isOrganic ? .green : .gray)
                            }
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.product.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("Çiftçi: \(item.product.farmerName)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            if item.product.isOrganic {
                                HStack(spacing: 2) {
                                    Image(systemName: "leaf.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                    Text("Organik")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                            
                            Text("\(item.quantity, specifier: "%.1f") \(item.product.unit)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("₺\(item.totalPrice, specifier: "%.2f")")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("₺\(item.unitPrice, specifier: "%.2f")/\(item.product.unit)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var deliveryAddressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Teslimat Adresi")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(order.deliveryAddress.title)
                    .fontWeight(.medium)
                
                Text(order.deliveryAddress.fullAddress)
                    .font(.subheadline)
                
                Text("\(order.deliveryAddress.district), \(order.deliveryAddress.city)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var priceBreakdownSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Ürün Toplamı")
                Spacer()
                Text("₺\(order.totalAmount - order.shippingCost, specifier: "%.2f")")
            }
            
            if order.shippingCost > 0 {
                HStack {
                    Text("Kargo")
                    Spacer()
                    Text("₺\(order.shippingCost, specifier: "%.2f")")
                }
            } else {
                HStack {
                    Text("Kargo")
                    Spacer()
                    Text("Ücretsiz")
                        .foregroundColor(.green)
                }
            }
            
            Divider()
            
            HStack {
                Text("Toplam")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("₺\(order.totalAmount, specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private func statusIndex(_ status: OrderStatus) -> Int {
        OrderStatus.allCases.firstIndex(of: status) ?? 0
    }
}
