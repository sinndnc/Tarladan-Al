//
//  NextDeliveryCard.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/23/25.
//
import SwiftUI

struct NextDeliveryCard: View {
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Content
            VStack(spacing: 16) {
                // Header Section
                HStack(alignment: .top, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.green)
                            
                            Text("Sıradaki Teslimat")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("5 Ağustos Pazartesi")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "clock.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                            
                            Text("10:00 - 14:00 arası")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Change Button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            // Change delivery time action
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "pencil")
                                .font(.system(size: 12, weight: .medium))
                            Text("Değiştir")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                colors: [.blue, .blue.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    .scaleEffect(1.0)
                    .animation(.easeInOut(duration: 0.1), value: isExpanded)
                }
                
                // Action Buttons
                HStack(spacing: 12) {
                    // Pause Button
                    actionButton(
                        icon: "pause.circle.fill",
                        title: "Duraklat",
                        color: .orange,
                        backgroundColor: Color.orange.opacity(0.1)
                    ) {
                        // Pause action
                    }
                    
                    // Add Product Button
                    actionButton(
                        icon: "plus.circle.fill",
                        title: "Ürün Ekle",
                        color: .green,
                        backgroundColor: Color.green.opacity(0.1)
                    ) {
                        // Add product action
                    }
                }
                
                // Expand/Collapse Button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack(spacing: 6) {
                        Text(isExpanded ? "Daha Az" : "Detayları Gör")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 10, weight: .medium))
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                    .foregroundColor(.blue)
                    .padding(.vertical, 4)
                }
            }
            .padding(20)
            
            // Expandable Section
            if isExpanded {
                VStack(spacing: 16) {
                    Divider()
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("Teslimat Bilgileri")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 8) {
                            deliveryInfoRow(icon: "location.fill", title: "Adres", value: "Merkez Mah. Atatürk Cad. No:123")
                            deliveryInfoRow(icon: "phone.fill", title: "Telefon", value: "+90 555 123 45 67")
                            deliveryInfoRow(icon: "note.text", title: "Not", value: "Kapıcıya bırakabilirsiniz")
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 20)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.green.opacity(0.1), lineWidth: 1)
        )
    }
    
    private func actionButton(
        icon: String,
        title: String,
        color: Color,
        backgroundColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(color)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func deliveryInfoRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.blue)
                .frame(width: 16, height: 16)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .leading)
            
            Text(value)
                .font(.caption)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }
}
