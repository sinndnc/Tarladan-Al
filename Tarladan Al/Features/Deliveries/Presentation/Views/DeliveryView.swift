//
//  DeliveriesView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/1/25.
//
//
import SwiftUI

struct DeliveryView: View {
    
    @State private var selectedDelivery: Delivery?
    @EnvironmentObject private var deliveryViewModel: DeliveryViewModel
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading,spacing: 20) {
                    deliveryHeaderView
                    
                    deliveryScheduleView
                    
                    activeDeliveriesView
                    
                    deliveryHistoryView
                    
                    deliveryPreferenecesView
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading){
                        Text("Teslimatlar")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Teslimatlar hakkında her şey")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack{
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "line.3.horizontal")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedDelivery) { delivery in
            DeliveryDetailView(delivery: delivery)
        }
    }
    
    private var deliveryHeaderView: some View {
        VStack(alignment: .leading){
            Text("Güncel Teslimat")
                .font(.headline)
                .fontWeight(.semibold)
            if let currentDelivery = deliveryViewModel.deliveries.first(where: { $0.status == .inTransit }) {
                CurrentDeliveryCard(delivery: currentDelivery) {
                    selectedDelivery = currentDelivery
                }
            }else{
                HStack{
                    Text("You don't have an current delivery.You have to wait until next week 😔")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
        }
    }
    
    private var activeDeliveriesView: some View {
        VStack(alignment: .leading){
            Text("Aktif Teslimatlar")
                .font(.headline)
                .fontWeight(.semibold)
            
            ForEach(activeDeliveries) { delivery in
                DeliveryCard(delivery: delivery) {
                    selectedDelivery = delivery
                }
            }
        }
    }
    
    private var deliveryHistoryView: some View {
        VStack(alignment: .leading){
            Text("Geçmiş Teslimatlar")
                .font(.headline)
                .fontWeight(.semibold)
            
            ForEach(completedDeliveries) { delivery in
                DeliveryCard(delivery: delivery) {
                    selectedDelivery = delivery
                }
            }
        }
    }
    
    private var deliveryScheduleView: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 15) {
                Text("Sonraki Teslimat")
                    .font(.headline)
                    .fontWeight(.semibold)
                NextDeliveryCard()
            }
            
            // Weekly schedule
            VStack(alignment: .leading, spacing: 15) {
                Text("Haftalık Program")
                    .font(.headline)
                    .fontWeight(.semibold)
                WeeklyScheduleView()
            }
        }
    }
    
    private var deliveryPreferenecesView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Teslimat Tercihleri")
                .font(.headline)
                .fontWeight(.semibold)
            
            DeliveryPreferencesCard()
        }
    }
    
    private var activeDeliveries: [Delivery] {
        deliveryViewModel.deliveries.filter { $0.status != .delivered }
    }
    
    private var completedDeliveries: [Delivery] {
        deliveryViewModel.deliveries.filter { $0.status == .delivered }
    }
}

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
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.blue.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DeliveryCard: View {
    let delivery: Delivery
    let action: () -> Void
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, HH:mm"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    HStack {
                        Image(systemName: delivery.status.icon)
                            .foregroundColor(delivery.status.color)
                        Text(delivery.status.displayName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(delivery.status.color)
                    }
                    
                    Spacer()
                    
                    Text(delivery.scheduledDeliveryDate,style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Sipariş #\(delivery.orderNumber)")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Text("\(delivery.items.count) ürün • \(delivery.scheduledDeliveryDate.description)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(delivery.items.prefix(2).map { "\($0.productName) (\($0.quantity) adet)" }.joined(separator: ", ") +
                         (delivery.items.count > 2 ? " ve \(delivery.items.count - 2) diğer..." : ""))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                HStack {
                    Text(delivery.orderNumber)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NextDeliveryCard: View {
    var body: some View {
        VStack(spacing: 15) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("5 Ağustos Pazartesi")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("10:00 - 14:00 arası")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Text("Değiştir")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(5)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            HStack(spacing: 15) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "pause.fill")
                        Text("Duraklat")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Spacer()
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Ürün Ekle")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct WeeklyScheduleView: View {
    let weekDays = [
        ("Pzt", false), ("Sal", false), ("Çar", true),
        ("Per", false), ("Cum", false), ("Cmt", true), ("Paz", false)
    ]
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                ForEach(0..<weekDays.count, id: \.self) { index in
                    VStack(spacing: 8) {
                        Text(weekDays[index].0)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Circle()
                            .fill(weekDays[index].1 ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: weekDays[index].1 ? "truck.box.fill" : "")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            )
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            Text("Çarşamba ve Cumartesi günleri teslimat yapılır")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct DeliveryPreferencesCard: View {
    var body: some View {
        VStack(spacing: 15) {
            PreferenceRow(icon: "location.fill", title: "Teslimat Adresi",
                         subtitle: "Atatürk Mah. 123. Sk. No:45", color: .blue)
            
            PreferenceRow(icon: "clock.fill", title: "Tercih Edilen Zaman",
                         subtitle: "10:00 - 14:00 arası", color: .orange)
            
            PreferenceRow(icon: "bell.fill", title: "Bildirimler",
                         subtitle: "SMS ve Push bildirimleri", color: .purple)
            
            PreferenceRow(icon: "note.text", title: "Özel Talimatlar",
                         subtitle: "Kapıya bırakın", color: .green)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct PreferenceRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}


#Preview {
    DeliveryView()
}
