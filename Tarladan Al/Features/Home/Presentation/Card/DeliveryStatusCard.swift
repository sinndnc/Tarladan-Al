//
//  DeliveryStatusCard.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/23/25.
//
import SwiftUI
import Foundation

struct DeliveryStatusCard : View {
    
    let delivery: Delivery?
    
    var body : some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Sıradaki Teslimat")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Colors.Text.primary)
                
                Spacer()
                
                if let delivery = delivery, delivery.status != .inTransit {
                    Button(action: {
                        // viewModel.changeDeliveryTime()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.caption)
                            Text("Değiştir")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.blue.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            if let delivery = delivery {
                VStack(alignment: .leading,spacing: 16) {
                    // Dates Section
                    VStack(spacing: 12) {
                        deliveryDateRow(
                            title: "Güncel Teslimat",
                            date: delivery.actualDeliveryDate ?? .now,
                            isActual: true
                        )
                        
                        deliveryDateRow(
                            title: "Planlanan Teslimat",
                            date: delivery.scheduledDeliveryDate,
                            isActual: false
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Progress Bar
                    progressBar(for: delivery.status)
                        .padding(.horizontal, 20)
                    
                    // Status and Order Info
                    HStack(spacing: 12) {
                        // Status Icon
                        ZStack {
                            Circle()
                                .fill(delivery.status.color.opacity(0.1))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: delivery.status.icon)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(delivery.status.color)
                        }
                        
                        // Status Info
                        VStack(alignment: .leading, spacing: 4) {
                            Text(delivery.status.displayName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Sipariş #\(delivery.orderNumber)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Details Button
                        NavigationLink(destination: DeliveryDetailView(delivery: delivery)) {
                            HStack(spacing: 6) {
                                Text("Detaylar")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 10, weight: .medium))
                            }
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            } else {
                // Empty State
                VStack(spacing: 12) {
                    Image(systemName: "truck.box")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary.opacity(0.6))
                    
                    Text("Bekleyen teslimat yok")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text("Yeni siparişleriniz burada görünecek")
                        .font(.caption)
                        .foregroundColor(.secondary.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(
                    color: .black.opacity(0.06),
                    radius: 12,
                    x: 0,
                    y: 4
                )
        )
    }
    
    
    
    // MARK: - Helper Views
    func deliveryDateRow(title: String, date: Date, isActual: Bool) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(DateFormatter.shortFormatter.string(from: date))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(isActual ? .primary : .secondary)
            }
            
            Spacer()
            
            if isActual {
                Image(systemName: "clock.fill")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.05))
        )
    }

    func progressBar(for status: DeliveryStatus) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Progress Track
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 6)
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient(
                                colors: [status.color, status.color.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * status.progressValue, height: 6)
                        .animation(.easeInOut(duration: 0.6), value: status.progressValue)
                }
            }
            .frame(height: 6)
            
            // Progress Labels
            HStack {
                ForEach(DeliveryStatus.allCases.filter { $0 != .cancelled }, id: \.self) { deliveryStatus in
                    VStack(spacing: 4) {
                        Circle()
                            .fill(status.progressValue >= deliveryStatus.progressValue ? status.color : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                        
                        Text(deliveryStatus.displayName)
                            .font(.system(size: 9))
                            .fontWeight(.medium)
                            .foregroundColor(status.progressValue >= deliveryStatus.progressValue ? .primary : .secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    
                    if deliveryStatus != DeliveryStatus.allCases.filter({ $0 != .cancelled }).last {
                        Spacer()
                    }
                }
            }
        }
    }
    
}
