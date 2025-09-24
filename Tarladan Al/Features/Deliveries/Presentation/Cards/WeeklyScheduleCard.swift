//
//  WeeklyScheduleView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/23/25.
//
import SwiftUI

struct WeeklyScheduleCard: View {
    @State private var selectedDay: Int? = nil
    
    let weekDays: [(String, Bool)] = [
        ("Pzt", false), ("Sal", false), ("Çar", true),
        ("Per", false), ("Cum", false), ("Cmt", true), ("Paz", false)
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Haftalık Teslimat Programı")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Düzenli teslimat günleriniz")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "gear")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            
            // Days Grid
            HStack(spacing: 0) {
                ForEach(0..<weekDays.count, id: \.self) { index in
                    VStack(spacing: 12) {
                        // Day Label
                        Text(weekDays[index].0)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        // Day Circle
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedDay = selectedDay == index ? nil : index
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(weekDays[index].1 ? 
                                          LinearGradient(colors: [.green, .green.opacity(0.8)], startPoint: .top, endPoint: .bottom) :
                                          LinearGradient(colors: [Color.gray.opacity(0.15), Color.gray.opacity(0.1)], startPoint: .top, endPoint: .bottom))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Circle()
                                            .stroke(weekDays[index].1 ? Color.green.opacity(0.3) : Color.clear, lineWidth: 4)
                                            .frame(width: 44, height: 44)
                                    )
                                
                                if weekDays[index].1 {
                                    Image(systemName: "truck.box.fill")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white)
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.4))
                                        .frame(width: 8, height: 8)
                                }
                            }
                        }
                        .scaleEffect(selectedDay == index ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: selectedDay)
                        
                        // Status Indicator
                        if weekDays[index].1 {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 4, height: 4)
                        } else {
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 4, height: 4)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)
            
            // Info Section
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text("Çarşamba ve Cumartesi günleri teslimat yapılır")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                    
                    Text("Teslimat saati: 09:00 - 18:00 arası")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.1), lineWidth: 1)
                    )
            )
            
            // Quick Actions
            HStack(spacing: 12) {
                quickActionButton(
                    icon: "plus.circle.fill",
                    title: "Gün Ekle",
                    color: .green
                ) {
                    // Add day action
                }
                
                quickActionButton(
                    icon: "calendar",
                    title: "Programı Düzenle",
                    color: .blue
                ) {
                    // Edit schedule action
                }
            }
        }
        .padding(10)
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
    
    private func quickActionButton(
        icon: String,
        title: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .medium))
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(color.opacity(0.1))
            .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
