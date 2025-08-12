//
//  DeliveryDetailView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/12/25.
//
import SwiftUI
import Foundation

struct DeliveryDetailView: View {
    let delivery: Delivery
    @State private var showTrackingView = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter
    }
    
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TRY"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter
    }
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header Card
                    headerSection
                    
                    // Status Section
                    statusSection
                    
                    // Customer Information
                    customerSection
                    
                    // Items Section
                    itemsSection
                    
                    // Pricing Section
                    pricingSection
                    
                    // Special Instructions
                    if let instructions = delivery.specialInstructions {
                        instructionsSection(instructions)
                    }
                    
                    // Driver Notes
                    if let notes = delivery.driverNotes {
                        driverNotesSection(notes)
                    }
                    
                    // Action Button
                    actionButton
                }
                .padding()
            }
            .navigationTitle("Sipariş Detayı")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showTrackingView) {
                DeliveryTrackingView(delivery: delivery)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Sipariş #\(delivery.orderNumber)")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Oluşturulma: \(dateFormatter.string(from: delivery.createdAt))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Image(systemName: delivery.status.icon)
                        .font(.title2)
                        .foregroundColor(delivery.status.color)
                    
                    Text(delivery.status.displayName)
                        .font(.caption)
                        .foregroundColor(delivery.status.color)
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Teslimat Durumu")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 0) {
                ForEach(DeliveryStatus.allCases.filter { $0 != .cancelled }, id: \.self) { status in
                    VStack(alignment: .center,spacing: 4) {
                        HStack(spacing: 5){
                            if status != .pending {
                                Rectangle()
                                    .fill(delivery.status.progressValue >= status.progressValue ? Color.green : Color.gray.opacity(0.3))
                                    .cornerRadius(5,corners: [UIRectCorner.topRight, UIRectCorner.bottomRight])
                                    .frame(height: 2)
                            }else {
                                Rectangle()
                                    .fill(.clear)
                            }
                            
                            Circle()
                                .fill(delivery.status.progressValue >= status.progressValue ? status.color : Color.gray.opacity(0.3))
                                .frame(width: 12, height: 12)
                            
                            if status != .delivered {
                                Rectangle()
                                    .fill(delivery.status.progressValue > status.progressValue ? Color.green : Color.gray.opacity(0.3))
                                    .cornerRadius(5,corners: [UIRectCorner.topLeft, UIRectCorner.bottomLeft])
                                    .frame(height: 2)
                            }else {
                                Rectangle()
                                    .fill(.clear)
                            }
                        }
                        Text(status.displayName)
                            .font(.caption2)
                    }
                }
            }
            
            Text("Planlanan Teslimat: \(dateFormatter.string(from: delivery.scheduledDeliveryDate))")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2)
    }
    
    private var customerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Müşteri Bilgileri")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.blue)
                        .frame(width: 20)
                    Text(delivery.customer.name)
                }
                
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.green)
                        .frame(width: 20)
                    Text(delivery.customer.phone)
                }
                
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.red)
                        .frame(width: 20)
                    Text(delivery.customer.address.fullAddress)
                        .multilineTextAlignment(.leading)
                }
                
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.orange)
                        .frame(width: 20)
                    Text(delivery.customer.email)
                }
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2)
    }
    
    private var itemsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sipariş İçeriği (\(delivery.items.count) ürün)")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVStack(spacing: 8) {
                ForEach(delivery.items,id:\.self) { item in
                    HStack {
//                        AsyncImage(url: URL(string: item.imageURL ?? "")) { image in
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                        } placeholder: {
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(Color.gray.opacity(0.3))
//                        }
//                        .frame(width: 50, height: 50)
//                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.productName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text("\(item.quantity) adet × \(currencyFormatter.string(from: NSNumber(value: item.pricePerUnit)) ?? "₺0")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(currencyFormatter.string(from: NSNumber(value: item.totalPrice)) ?? "₺0")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2)
    }
    
    private var pricingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ödeme Özeti")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 8) {
                HStack {
                    Text("Ürünler Toplamı")
                    Spacer()
                    Text(currencyFormatter.string(from: NSNumber(value: delivery.totalAmount)) ?? "₺0")
                }
                
                HStack {
                    Text("Teslimat Ücreti")
                    Spacer()
                    Text(currencyFormatter.string(from: NSNumber(value: delivery.deliveryFee)) ?? "₺0")
                }
                
                Divider()
                
                HStack {
                    Text("Genel Toplam")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(currencyFormatter.string(from: NSNumber(value: delivery.totalAmount + delivery.deliveryFee)) ?? "₺0")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2)
    }
    
    private func instructionsSection(_ instructions: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Özel Talimatlar")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(instructions)
                .font(.subheadline)
                .padding(.vertical)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2)
    }
    
    private func driverNotesSection(_ notes: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Kurye Notları")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(notes)
                .font(.subheadline)
                .padding(.vertical)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2)
    }
    
    private var actionButton: some View {
        Button(action: {
            showTrackingView = true
        }) {
            HStack {
                Image(systemName: "location.fill")
                Text("Siparişi Takip Et")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
        }
        .disabled(delivery.status == .delivered || delivery.status == .cancelled)
    }
}
