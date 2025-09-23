//
//  CurrentDeliveryCard.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/23/25.
//
import SwiftUI

struct CurrentDeliveryCard: View {
    let delivery: Delivery
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            Image(systemName: delivery.status.icon)
                                .foregroundColor(.green)
                            Text(delivery.status.displayName)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                        }
                        
                        Text("Tahmini Teslimat: \(DateFormatter.shortFormatter.string(from: delivery.scheduledDeliveryDate))")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Text("#\(delivery.orderNumber)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                // Progress bar
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("İlerleme")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("%\(delivery.status.progressValue)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                    
                    ProgressView(value: delivery.status.progressValue)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                }
            }
            .padding(20)
            .background(Colors.System.surface)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.05), radius: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
