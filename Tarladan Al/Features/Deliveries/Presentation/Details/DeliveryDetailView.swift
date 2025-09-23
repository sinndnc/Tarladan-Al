//
//  DeliveryDetailView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/12/25.
//
import SwiftUI
import MapKit

// MARK: - Enhanced Delivery Detail View
struct DeliveryDetailView: View {
    let delivery: Delivery
    @Environment(\.dismiss) private var dismiss
    @State private var showingFullScreenMap = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                // Header Section
                headerSection
                
                // Map Card
                deliveryMapCard
                
                // Status Progress
                statusProgressSection
                
                // Customer Info
                customerInfoSection
                
                // Items Summary
                itemsSummarySection
                
                // Actions Section
                actionsSection
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
        }
        .fullScreenCover(isPresented: $showingFullScreenMap) {
            DeliveryFullScreenMapView(delivery: delivery)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Teslimat")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .tracking(1)
                    
                    Text("#\(delivery.orderNumber)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(delivery.status.color)
                            .frame(width: 8, height: 8)
                        
                        Text(delivery.status.displayName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(delivery.status.color)
                    }
                    
                    Text("₺\(delivery.totalAmount + delivery.deliveryFee, specifier: "%.0f")")
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
            
            HStack {
                Text(delivery.createdAt, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if delivery.status == .inTransit {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.caption)
                        Text("15-25 dk kaldı")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .clipShape(Capsule())
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
    
    private var deliveryMapCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Konum Takibi")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(delivery.customer.address.district + ", " + delivery.customer.address.city)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button {
                    showingFullScreenMap = true
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            
            ZStack {
                // Map View
                if let currentLocation = delivery.currentLocation {
                    Map(coordinateRegion: .constant(MKCoordinateRegion(
                        center: currentLocation.toLocation2D,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01),
                    )) ,annotationItems:  [SingleAnnotation(coordinate: currentLocation.toLocation2D)]) { _ in
                        MapPin(coordinate: currentLocation.toLocation2D, tint: delivery.status.color)
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .allowsHitTesting(false)
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                        .frame(height: 200)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "location.slash")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                Text("Konum bilgisi yok")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        )
                }
                
                // Tap overlay
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showingFullScreenMap = true
                    }
                
                // Driver info overlay
                if delivery.status == .inTransit {
                    VStack {
                        Spacer()
                        HStack {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(.green)
                                    .frame(width: 8, height: 8)
                                
                                Text("Sürücü yolda")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Capsule())
                            
                            Spacer()
                        }
                        .padding(16)
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
    
    private var statusProgressSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Teslimat Durumu")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading,spacing: 10) {
                ForEach(Array(DeliveryStatus.allCases.filter { $0 != .cancelled }.enumerated()), id: \.element) { index, status in
                    let isCompleted = delivery.status.progressValue >= status.progressValue
                    let isCurrent = delivery.status == status
                    
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
                            Text(status.displayName)
                                .font(.subheadline)
                                .fontWeight(isCurrent ? .semibold : .medium)
                                .foregroundColor(isCompleted ? .primary : .secondary)
                            
                            if isCurrent {
                                Text("Şu anda bu aşamada")
                                    .font(.caption)
                                    .foregroundColor(status.color)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    if index < DeliveryStatus.allCases.filter({ $0 != .cancelled }).count - 1 {
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
    
    private var customerInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Müşteri Bilgileri")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if delivery.customer.isVipCustomer {
                    HStack(spacing: 4) {
                        Image(systemName: "crown.fill")
                            .font(.caption2)
                        Text("VIP")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .clipShape(Capsule())
                }
            }
            
            VStack(spacing: 12) {
                CustomerInfoRow(
                    icon: "person.fill",
                    title: "Müşteri",
                    value: delivery.customer.name
                )
                
                CustomerInfoRow(
                    icon: "phone.fill",
                    title: "Telefon",
                    value: delivery.customer.phone,
                    isCallable: true
                )
                
                CustomerInfoRow(
                    icon: "location.fill",
                    title: "Adres",
                    value: delivery.customer.address.fullAddress
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
    
    private var itemsSummarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Sipariş Özeti")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(delivery.items.count) ürün")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("Ürün Tutarı")
                        .font(.subheadline)
                    Spacer()
                    Text("₺\(delivery.totalAmount, specifier: "%.0f")")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                HStack {
                    Text("Teslimat Ücreti")
                        .font(.subheadline)
                    Spacer()
                    if delivery.deliveryFee > 0 {
                        Text("₺\(delivery.deliveryFee, specifier: "%.0f")")
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
                    Text("₺\(delivery.totalAmount + delivery.deliveryFee, specifier: "%.0f")")
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
    
    private var actionsSection: some View {
        VStack(spacing: 12) {
            if delivery.status == .inTransit {
                ActionButton(
                    title: "Teslimatı Tamamla",
                    icon: "checkmark.circle.fill",
                    color: .green
                ) {
                    // Complete delivery action
                }
            }
            
            ActionButton(
                title: "Müşteriyi Ara",
                icon: "phone.fill",
                color: .blue
            ) {
                if let url = URL(string: "tel:\(delivery.customer.phone)") {
                    UIApplication.shared.open(url)
                }
            }
            
            if delivery.status != .delivered {
                ActionButton(
                    title: "Teslimat Saatini Değiştir",
                    icon: "calendar",
                    color: .orange
                ) {
                    // Reschedule action
                }
            }
        }
    }
}


// MARK: - Supporting Views
struct CustomerInfoRow: View {
    let icon: String
    let title: String
    let value: String
    var isCallable: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isCallable ? .blue : .primary)
            }
            
            Spacer()
            
            if isCallable {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            if isCallable, let url = URL(string: "tel:\(value)") {
                UIApplication.shared.open(url)
            }
        }
    }
}


struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [color, color.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
