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
                                .foregroundColor(delivery.status.color)
                            Text(delivery.status.displayName)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(delivery.status.color)
                        }
                        
                        Text("Tahmini Teslimat: \(delivery.scheduledDeliveryDate)")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Text("#\(delivery.orderNumber)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                        
                        Text("Takip Et")
                            .font(.caption)
                            .foregroundColor(.green)
                            .fontWeight(.medium)
                    }
                }
                
                // Progress bar
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("İlerleme")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("75%")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                    
                    ProgressView(value: 0.75)
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
                
//                VStack(alignment: .leading, spacing: 6) {
//                    Text("Sipariş #\(delivery.orderNumber)")
//                        .font(.headline)
//                        .fontWeight(.medium)
//                    
//                    Text("\(delivery.items.count) ürün • \(delivery.scheduledDeliveryDate.description)")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                    
//                    Text(delivery.items.prefix(2).joined(separator: ", ") +
//                         (delivery.items.count > 2 ? " ve \(delivery.items.count - 2) diğer..." : ""))
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                        .lineLimit(1)
//                }
                
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

//struct DeliveryDetailView: View {
//    let delivery: Delivery
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 20) {
//                    // Tracking map placeholder
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(Color.blue.opacity(0.1))
//                        .frame(height: 200)
//                        .overlay(
//                            VStack {
//                                Image(systemName: "map.fill")
//                                    .font(.system(size: 40))
//                                    .foregroundColor(.blue)
//                                Text("Canlı Takip")
//                                    .font(.headline)
//                                    .fontWeight(.semibold)
//                                    .foregroundColor(.blue)
//                            }
//                        )
//                    
//                    // Delivery details
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Teslimat Detayları")
//                            .font(.headline)
//                            .fontWeight(.semibold)
//                        
//                        VStack(spacing: 12) {
//                            DetailRow(title: "Sipariş No", value: delivery.orderNumber)
//                            DetailRow(title: "Takip Kodu", value: delivery.orderNumber)
//                            DetailRow(title: "Durum", value: delivery.status.displayName)
//                            DetailRow(title: "Tahmini Teslimat", value: delivery.scheduledDeliveryDate.description)
//                            DetailRow(title: "Adres", value: delivery.customer.address.fullAddress)
//                        }
//                    }
//                    
//                    // Items list
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Ürünler (\(delivery.items.count))")
//                            .font(.headline)
//                            .fontWeight(.semibold)
//                        
//                        VStack(spacing: 8) {
////                            ForEach(delivery.items, id: \.self) { item in
////                                HStack {
////                                    Image(systemName: "leaf.fill")
////                                        .foregroundColor(.green)
////                                    Text(item.productName)
////                                        .font(.subheadline)
////                                    Spacer()
////                                }
////                                .padding(.vertical, 4)
////                            }
//                        }
//                        .padding(15)
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                    }
//                }
//                .padding(20)
//            }
//            .navigationTitle("Teslimat Takibi")
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarItems(
//                trailing: Button("Kapat") {
//                    presentationMode.wrappedValue.dismiss()
//                }
//            )
//        }
//    }
//}

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

//import SwiftUI
//
//struct DeliveriesView: View {
//    
//    @State private var showingCreateDelivery = false
//    @StateObject private var viewModel: DeliveriesViewModel = DeliveriesViewModel()
//    
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 0) {
//                // Search and Filter Section
//                VStack(spacing: 12) {
//                    DeliverySearchBar(text: $viewModel.searchText)
//                    
////                    StatusFilterView(selectedStatus: $viewModel.selectedStatus) {
////                        viewModel.loadDeliveries()
////                    }
//                }
//                .padding()
//                .background(Color(.systemGray6))
//                
//                // Deliveries List
//                if viewModel.isLoading {
//                    Spacer()
//                    ProgressView("Teslimatlar yükleniyor...")
//                    Spacer()
//                } else if viewModel.filteredDeliveries.isEmpty {
//                    Spacer()
//                    Text("Empty")
//                    Spacer()
//                } else {
//                    List(viewModel.filteredDeliveries) { delivery in
//                        NavigationLink{
//                            
//                        } label:{
//                            DeliveryCard(delivery: delivery) { newStatus in
//                                viewModel.updateDeliveryStatus(delivery, newStatus: newStatus)
//                            }
//                        }
//                        .listRowSeparator(.hidden)
//                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
//                    }
//                    .listStyle(PlainListStyle())
//                    .refreshable {
//                        viewModel.refreshDeliveries()
//                    }
//                }
//            }
//            .navigationTitle("Teslimatlar")
//            .navigationBarTitleDisplayMode(.large)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        showingCreateDelivery = true
//                    } label: {
//                        Image(systemName: "plus.circle.fill")
//                    }
//                }
//            }
//            .onAppear {
//                viewModel.loadDeliveries()
//            }
//            .alert("Hata", isPresented: .constant(viewModel.errorMessage != nil)) {
//                Button("Tamam") {
//                    viewModel.errorMessage = nil
//                }
//            } message: {
//                Text(viewModel.errorMessage ?? "")
//            }
//        }
//    }
//}
//
//// Presentation/Views/Components/DeliveryCard.swift
//struct DeliveryCard: View {
//    let delivery: Delivery
//    let onStatusUpdate: (DeliveryStatus) -> Void
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            // Header
//            HStack {
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(delivery.orderNumber)
//                        .font(.headline)
//                        .fontWeight(.semibold)
//                    
//                    Text(delivery.customer.name)
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//                
//                Spacer()
//                
//                StatusBadge(status: delivery.status)
//            }
//            
//            // Delivery Info
//            HStack {
//                VStack(alignment: .leading, spacing: 2) {
//                    Label("Teslimat Tarihi", systemImage: "calendar")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                    
//                    Text(delivery.scheduledDeliveryDate.formatted(date: .abbreviated, time: .shortened))
//                        .font(.subheadline)
//                        .fontWeight(.medium)
//                }
//                
//                Spacer()
//                
//                VStack(alignment: .trailing, spacing: 2) {
//                    Text("Toplam")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                    
//                    Text("₺\(delivery.totalAmount, specifier: "%.2f")")
//                        .font(.subheadline)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.primary)
//                }
//            }
//            
//            // Items Summary
//            HStack {
//                Label("\(delivery.items.count) ürün", systemImage: "box")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                
//                if delivery.items.contains(where: { $0.isTemperatureSensitive }) {
//                    Label("Soğuk zincir", systemImage: "thermometer.snowflake")
//                        .font(.caption)
//                        .foregroundColor(.blue)
//                }
//                
//                Spacer()
//            }
//            
//            // Action Buttons for certain statuses
//            if delivery.status == .confirmed || delivery.status == .preparing {
//                HStack(spacing: 12) {
//                    if delivery.status == .confirmed {
//                        Button("Hazırlamaya Başla") {
//                            onStatusUpdate(.preparing)
//                        }
//                        .buttonStyle(.borderedProminent)
//                        .controlSize(.small)
//                    }
//                    
//                    if delivery.status == .preparing {
//                        Button("Yola Çıkar") {
//                            onStatusUpdate(.inTransit)
//                        }
//                        .buttonStyle(.borderedProminent)
//                        .controlSize(.small)
//                    }
//                    
//                    Button("İptal Et") {
//                        onStatusUpdate(.cancelled)
//                    }
//                    .buttonStyle(.bordered)
//                    .controlSize(.small)
//                    .foregroundColor(.red)
//                }
//            }
//        }
//        .padding(16)
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
//    }
//}
//
//// Presentation/Views/Components/StatusBadge.swift
//struct StatusBadge: View {
//    let status: DeliveryStatus
//    
//    var body: some View {
//        Text(status.displayName)
//            .font(.caption)
//            .fontWeight(.semibold)
//            .padding(.horizontal, 8)
//            .padding(.vertical, 4)
//            .background(status.color.opacity(0.2))
//            .foregroundColor(status.color)
//            .cornerRadius(6)
//    }
//}
//
//// Presentation/Views/Components/DeliverySearchBar.swift
//struct DeliverySearchBar: View {
//    @Binding var text: String
//    
//    var body: some View {
//        HStack {
//            Image(systemName: "magnifyingglass")
//                .foregroundColor(.secondary)
//            
//            TextField("Sipariş numarası veya müşteri adı ara...", text: $text)
//                .textFieldStyle(PlainTextFieldStyle())
//            
//            if !text.isEmpty {
//                Button("Temizle") {
//                    text = ""
//                }
//                .font(.caption)
//                .foregroundColor(.blue)
//            }
//        }
//        .padding(.horizontal, 12)
//        .padding(.vertical, 8)
//        .background(Color(.systemBackground))
//        .cornerRadius(10)
//    }
//}
//-------------------------------------------------------------------------------------------------------
//struct DeliveriesView: View {
//    
//    @StateObject private var viewModel: DeliveriesViewModel
//    
//    init(
//        viewModel: DeliveriesViewModel = DIContainer.shared.resolve()
//    ) {
//        self._viewModel = StateObject(wrappedValue: viewModel)
//    }
//    
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 0) {
//                    // Current Delivery Header
//                    if let currentDelivery = viewModel.currentDelivery {
//                        deliveryHeaderView(currentDelivery)
//                    }
//                    
//                    // Delivery Schedule
//                    deliveryScheduleView
//                    
//                    // Active Deliveries
//                    activeDeliveriesView
//                    
//                    // Delivery History
//                    deliveryHistoryView
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    VStack(alignment: .leading) {
//                        Text("Teslimatlar")
//                            .font(.headline)
//                            .fontWeight(.bold)
//                        Text("Teslimatlar hakkında her şey")
//                            .font(.caption)
//                            .fontWeight(.medium)
//                            .foregroundStyle(.gray)
//                    }
//                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    HStack {
//                        Button(action: {
//                            Task {
//                                await viewModel.enableNotifications()
//                            }
//                        }) {
//                            Image(systemName: "bell")
//                                .font(.subheadline)
//                                .fontWeight(.semibold)
//                                .foregroundColor(.primary)
//                        }
//                        
//                        Button(action: {}) {
//                            Image(systemName: "line.3.horizontal")
//                                .font(.subheadline)
//                                .fontWeight(.semibold)
//                                .foregroundColor(.primary)
//                        }
//                    }
//                }
//            }
//            .refreshable {
//                await viewModel.refresh()
//            }
//            .alert("Hata", isPresented: $viewModel.showingError) {
//                Button("Tamam", action: viewModel.clearError)
//            } message: {
//                if let errorMessage = viewModel.errorMessage {
//                    Text(errorMessage)
//                }
//            }
//        }
//        .sheet(item: $viewModel.selectedDelivery) { delivery in
//            DeliveryDetailView(delivery: delivery, viewModel: viewModel)
//        }
//    }
//    
//    private func deliveryHeaderView(_ delivery: Delivery) -> some View {
//        VStack(alignment: .leading) {
//            Text("Güncel Teslimat")
//                .font(.headline)
//                .fontWeight(.semibold)
//            
//            CurrentDeliveryCard(delivery: delivery) {
//                viewModel.selectDelivery(delivery)
//            }
//        }
//        .padding()
//    }
//    
//    private var activeDeliveriesView: some View {
//        VStack(alignment: .leading) {
//            Text("Aktif Teslimatlar")
//                .font(.headline)
//                .fontWeight(.semibold)
//            
//            if viewModel.isLoadingDeliveries {
//                HStack {
//                    Spacer()
//                    ProgressView()
//                        .padding()
//                    Spacer()
//                }
//            } else if viewModel.activeDeliveries.isEmpty {
//                Text("Aktif teslimat bulunmuyor")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                    .padding()
//            } else {
//                ForEach(viewModel.activeDeliveries) { delivery in
//                    DeliveryCardView(delivery: delivery) {
//                        viewModel.selectDelivery(delivery)
//                    }
//                }
//            }
//        }
//        .padding()
//    }
//    
//    private var deliveryHistoryView: some View {
//        VStack(alignment: .leading) {
//            Text("Geçmiş Teslimatlar")
//                .font(.headline)
//                .fontWeight(.semibold)
//            
//            if viewModel.completedDeliveries.isEmpty {
//                Text("Geçmiş teslimat bulunmuyor")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                    .padding()
//            } else {
//                ForEach(viewModel.completedDeliveries) { delivery in
//                    DeliveryCardView(delivery: delivery) {
//                        viewModel.selectDelivery(delivery)
//                    }
//                }
//            }
//        }
//        .padding()
//    }
//    
//    private var deliveryScheduleView: some View {
//           VStack(spacing: 20) {
//               // Next Delivery
//               if let nextDelivery = viewModel.nextDelivery {
//                   VStack(alignment: .leading, spacing: 15) {
//                       Text("Sonraki Teslimat")
//                           .font(.headline)
//                           .fontWeight(.semibold)
//                       
//                       NextDeliveryCard(nextDelivery: nextDelivery, viewModel: viewModel)
//                   }
//                   .padding()
//               }
//               
//               // Weekly Schedule
//               VStack(alignment: .leading, spacing: 15) {
//                   Text("Haftalık Program")
//                       .font(.headline)
//                       .fontWeight(.semibold)
//                   
//                   if viewModel.isLoadingSchedule {
//                       HStack {
//                           Spacer()
//                           ProgressView()
//                               .padding()
//                           Spacer()
//                       }
//                   } else {
//                       WeeklyScheduleView(weekDaysData: viewModel.weeklyScheduleDisplay)
//                   }
//               }
//               .padding()
//               
//               // Delivery Preferences
//               if let preferences = viewModel.deliveryPreferences {
//                   VStack(alignment: .leading, spacing: 15) {
//                       Text("Teslimat Tercihleri")
//                           .font(.headline)
//                           .fontWeight(.semibold)
//                       
//                       DeliveryPreferencesCard(preferences: preferences)
//                   }
//                   .padding()
//               }
//           }
//       }
//    
//}
//
//struct CurrentDeliveryCard: View {
//    let delivery: Delivery
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            VStack(spacing: 15) {
//                HStack {
//                    VStack(alignment: .leading, spacing: 8) {
//                        HStack {
//                            Image(systemName: delivery.status.icon)
//                                .foregroundColor(delivery.status.color)
//                            Text(delivery.status.displayText)
//                                .font(.headline)
//                                .fontWeight(.semibold)
//                                .foregroundColor(delivery.status.color)
//                        }
//                        
//                        Text("Tahmini Teslimat: \(delivery.estimatedTime)")
//                            .font(.subheadline)
//                            .foregroundColor(.primary)
//                        
//                        Text("#\(delivery.orderNumber)")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                    
//                    Spacer()
//                    
//                    VStack {
//                        Image(systemName: "location.fill")
//                            .font(.title2)
//                            .foregroundColor(.green)
//                        
//                        Text("Takip Et")
//                            .font(.caption)
//                            .foregroundColor(.green)
//                            .fontWeight(.medium)
//                    }
//                }
//                
//                // Progress bar
//                VStack(alignment: .leading, spacing: 8) {
//                    HStack {
//                        Text("İlerleme")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                        Spacer()
//                        Text("75%")
//                            .font(.caption)
//                            .fontWeight(.medium)
//                            .foregroundColor(.blue)
//                    }
//                    
//                    ProgressView(value: 0.75)
//                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
//                        .scaleEffect(x: 1, y: 2, anchor: .center)
//                }
//            }
//            .padding(20)
//            .background(
//                LinearGradient(
//                    colors: [Color.blue.opacity(0.1), Color.blue.opacity(0.05)],
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            )
//            .cornerRadius(15)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//
//struct DeliveryCardView: View {
//    let delivery: Delivery
//    let action: () -> Void
//    
//    private var dateFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MMM, HH:mm"
//        formatter.locale = Locale(identifier: "tr_TR")
//        return formatter
//    }
//    
//    var body: some View {
//        Button(action: action) {
//            VStack(alignment: .leading, spacing: 12) {
//                HStack {
//                    HStack {
//                        Image(systemName: delivery.status.icon)
//                            .foregroundColor(delivery.status.color)
//                        Text(delivery.status.displayText)
//                            .font(.subheadline)
//                            .fontWeight(.semibold)
//                            .foregroundColor(delivery.status.color)
//                    }
//                    
//                    Spacer()
//                    
//                    Text(dateFormatter.string(from: delivery.deliveryDate))
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
//                
//                VStack(alignment: .leading, spacing: 6) {
//                    Text("Sipariş #\(delivery.orderNumber)")
//                        .font(.headline)
//                        .fontWeight(.medium)
//                    
//                    Text("\(delivery.items.count) ürün • \(delivery.estimatedTime)")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                    
////                    Text(delivery.items.prefix(2).joined(separator: ", ") +
////                         (delivery.items.count > 2 ? " ve \(delivery.items.count - 2) diğer..." : ""))
////                        .font(.caption)
////                        .foregroundColor(.secondary)
////                        .lineLimit(1)
//                }
//                
//                HStack {
//                    Text(delivery.trackingCode)
//                        .font(.caption)
//                        .fontWeight(.medium)
//                        .foregroundColor(.blue)
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 4)
//                        .background(Color.blue.opacity(0.1))
//                        .cornerRadius(6)
//                    
//                    Spacer()
//                    
//                    Image(systemName: "chevron.right")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding(16)
//            .background(Color(.systemBackground))
//            .cornerRadius(12)
//            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//struct NextDeliveryCard: View {
//    let nextDelivery: NextDelivery
//    let viewModel: DeliveriesViewModel
//    
//    var body: some View {
//        VStack(spacing: 15) {
//            HStack {
//                VStack(alignment: .leading, spacing: 8) {
//                    Text(nextDelivery.formattedDate)
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .foregroundColor(.green)
//                    
//                    Text("\(nextDelivery.timeSlot.startTime) - \(nextDelivery.timeSlot.endTime) arası")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//                
//                Spacer()
//                
//                Button("Değiştir") {
//                    viewModel.changeDeliveryTime()
//                }
//                .font(.subheadline)
//                .fontWeight(.medium)
//                .foregroundColor(.blue)
//                .disabled(!nextDelivery.canModify)
//            }
//            
//            HStack(spacing: 15) {
//                Button(action: {
//                    Task {
//                        await viewModel.pauseNextDelivery()
//                    }
//                }) {
//                    HStack {
//                        Image(systemName: "pause.fill")
//                        Text("Duraklat")
//                    }
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//                    .foregroundColor(.orange)
//                    .padding(.horizontal, 16)
//                    .padding(.vertical, 8)
//                    .background(Color.orange.opacity(0.1))
//                    .cornerRadius(8)
//                }
//                
//                Button(action: {
//                    viewModel.addProductsToNextDelivery()
//                }) {
//                    HStack {
//                        Image(systemName: "plus")
//                        Text("Ürün Ekle")
//                    }
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//                    .foregroundColor(.green)
//                    .padding(.horizontal, 16)
//                    .padding(.vertical, 8)
//                    .background(Color.green.opacity(0.1))
//                    .cornerRadius(8)
//                }
//                
//                Spacer()
//            }
//            
//            // Items Preview
//            if !nextDelivery.items.isEmpty {
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Ürünler (\(nextDelivery.items.count))")
//                        .font(.caption)
//                        .fontWeight(.medium)
//                        .foregroundColor(.secondary)
//                    
//                    HStack {
//                        ForEach(nextDelivery.items.prefix(3)) { item in
//                            HStack(spacing: 4) {
//                                if let image = item.image {
//                                    Text(image)
//                                        .font(.caption)
//                                }
//                                Text(item.name)
//                                    .font(.caption)
//                                    .lineLimit(1)
//                            }
//                            .padding(.horizontal, 8)
//                            .padding(.vertical, 4)
//                            .background(Color(.systemGray6))
//                            .cornerRadius(6)
//                        }
//                        
//                        if nextDelivery.items.count > 3 {
//                            Text("+\(nextDelivery.items.count - 3)")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                        
//                        Spacer()
//                    }
//                }
//            }
//        }
//        .padding(20)
//        .background(Color(.systemGray6))
//        .cornerRadius(12)
//    }
//}
//
//struct WeeklyScheduleView: View {
//    let weekDaysData: [(String, Bool)]
//    
//    var body: some View {
//        VStack(spacing: 15) {
//            HStack {
//                ForEach(0..<weekDaysData.count, id: \.self) { index in
//                    VStack(spacing: 8) {
//                        Text(weekDaysData[index].0)
//                            .font(.caption)
//                            .fontWeight(.medium)
//                            .foregroundColor(.secondary)
//                        
//                        Circle()
//                            .fill(weekDaysData[index].1 ? Color.green : Color.gray.opacity(0.3))
//                            .frame(width: 30, height: 30)
//                            .overlay(
//                                Image(systemName: weekDaysData[index].1 ? "truck.box.fill" : "")
//                                    .font(.caption)
//                                    .foregroundColor(.white)
//                            )
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//            }
//            
//            Text("Çarşamba ve Cumartesi günleri teslimat yapılır")
//                .font(.caption)
//                .foregroundColor(.secondary)
//                .multilineTextAlignment(.center)
//        }
//        .padding(20)
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
//    }
//}
//
//
//struct DeliveryPreferencesCard: View {
//    let preferences: DeliveryPreference
//    
//    var body: some View {
//        VStack(spacing: 15) {
//            if let address = preferences.preferredAddress {
//                PreferenceRow(
//                    icon: "location.fill",
//                    title: "Teslimat Adresi",
//                    subtitle: "\(address.district), \(address.city)",
//                    color: .blue
//                )
//            }
//            
//            if let timeSlot = preferences.preferredTimeSlots.first {
//                PreferenceRow(
//                    icon: "clock.fill",
//                    title: "Tercih Edilen Zaman",
//                    subtitle: timeSlot,
//                    color: .orange
//                )
//            }
//            
//            PreferenceRow(
//                icon: "bell.fill",
//                title: "Bildirimler",
//                subtitle: getNotificationText(preferences.notificationSettings),
//                color: .purple
//            )
//            
//            if let instructions = preferences.specialInstructions {
//                PreferenceRow(
//                    icon: "note.text",
//                    title: "Özel Talimatlar",
//                    subtitle: instructions,
//                    color: .green
//                )
//            }
//        }
//        .padding(20)
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
//    }
//    
//    private func getNotificationText(_ settings: NotificationSettings) -> String {
//        var types: [String] = []
//        if settings.smsEnabled { types.append("SMS") }
//        if settings.pushEnabled { types.append("Push") }
//        if settings.emailEnabled { types.append("E-posta") }
//        return types.isEmpty ? "Kapalı" : types.joined(separator: " ve ") + " bildirimleri"
//    }
//}
//
//struct PreferenceRow: View {
//    let icon: String
//    let title: String
//    let subtitle: String
//    let color: Color
//    
//    var body: some View {
//        Button(action: {}) {
//            HStack(spacing: 15) {
//                Image(systemName: icon)
//                    .font(.title3)
//                    .foregroundColor(color)
//                    .frame(width: 30)
//                
//                VStack(alignment: .leading, spacing: 2) {
//                    Text(title)
//                        .font(.subheadline)
//                        .fontWeight(.medium)
//                        .foregroundColor(.primary)
//                    Text(subtitle)
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
//                
//                Spacer()
//                
//                Image(systemName: "chevron.right")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//
//
//struct DeliveryDetailView: View {
//    let delivery: Delivery
//    let viewModel: DeliveriesViewModel
//    @Environment(\.dismiss) var dismiss
//    @State private var showingCourierLocation = false
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 20) {
//                    // Live Tracking Map
//                    if delivery.status == .onWay {
//                        liveTrackingSection
//                    }
//                    
//                    // Delivery Status Progress
//                    deliveryStatusSection
//                    
//                    // Delivery Details
//                    deliveryDetailsSection
//                    
//                    // Items List
//                    itemsListSection
//                    
//                    // Courier Information
//                    if let courierInfo = delivery.courierInfo {
//                        courierInfoSection(courierInfo)
//                    }
//                    
//                    // Action Buttons
//                    actionButtonsSection
//                }
//                .padding(20)
//            }
//            .navigationTitle("Teslimat Takibi")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Kapat") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//    
//    private var liveTrackingSection: some View {
//        VStack(spacing: 12) {
//            Button(action: {
//                Task {
//                    await viewModel.startTrackingDelivery(delivery)
//                    showingCourierLocation = true
//                }
//            }) {
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color.blue.opacity(0.1))
//                    .frame(height: 200)
//                    .overlay(
//                        VStack(spacing: 12) {
//                            if viewModel.isTrackingCourier {
//                                ProgressView()
//                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
//                                Text("Konum güncelleniyor...")
//                                    .font(.subheadline)
//                                    .foregroundColor(.blue)
//                            } else {
//                                Image(systemName: "map.fill")
//                                    .font(.system(size: 40))
//                                    .foregroundColor(.blue)
//                                Text("Canlı Takip")
//                                    .font(.headline)
//                                    .fontWeight(.semibold)
//                                    .foregroundColor(.blue)
//                                Text("Kurye konumunu görüntüle")
//                                    .font(.caption)
//                                    .foregroundColor(.secondary)
//                            }
//                        }
//                    )
//            }
//            .disabled(viewModel.isTrackingCourier)
//        }
//    }
//    
//    private var deliveryStatusSection: some View {
//        VStack(alignment: .leading, spacing: 15) {
//            Text("Teslimat Durumu")
//                .font(.headline)
//                .fontWeight(.semibold)
//            
//            HStack {
//                VStack(alignment: .leading, spacing: 8) {
//                    HStack {
//                        Image(systemName: delivery.status.icon)
//                            .foregroundColor(delivery.status.color)
//                        Text(delivery.status.displayText)
//                            .font(.subheadline)
//                            .fontWeight(.semibold)
//                            .foregroundColor(delivery.status.color)
//                    }
//                    
//                    Text("Son güncelleme: \(DateFormatter.shortDateTime.string(from: delivery.updatedAt))")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
//                
//                Spacer()
//                
//                Text("\(Int(delivery.status.progressValue * 100))%")
//                    .font(.title3)
//                    .fontWeight(.bold)
//                    .foregroundColor(delivery.status.color)
//            }
//            
//            ProgressView(value: delivery.status.progressValue)
//                .progressViewStyle(LinearProgressViewStyle(tint: delivery.status.color))
//                .scaleEffect(x: 1, y: 3, anchor: .center)
//        }
//        .padding(20)
//        .background(Color(.systemGray6))
//        .cornerRadius(12)
//    }
//    
//    private var deliveryDetailsSection: some View {
//        VStack(alignment: .leading, spacing: 15) {
//            Text("Teslimat Detayları")
//                .font(.headline)
//                .fontWeight(.semibold)
//            
//            VStack(spacing: 12) {
//                DetailRowView(title: "Sipariş No", value: delivery.orderNumber)
//                DetailRowView(title: "Takip Kodu", value: delivery.trackingCode)
//                DetailRowView(title: "Durum", value: delivery.status.displayText)
//                DetailRowView(title: "Tahmini Teslimat", value: delivery.estimatedTime)
//                DetailRowView(title: "Adres", value: delivery.deliveryAddress.fullAddress)
//                
//                if let totalAmount = delivery.totalAmount {
//                    DetailRowView(title: "Toplam Tutar", value: "₺\(String(format: "%.2f", totalAmount))")
//                }
//                
//                if let instructions = delivery.specialInstructions {
//                    DetailRowView(title: "Özel Talimatlar", value: instructions)
//                }
//            }
//        }
//        .padding(20)
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
//    }
//    
//    private var itemsListSection: some View {
//        VStack(alignment: .leading, spacing: 15) {
//            Text("Ürünler (\(delivery.items.count))")
//                .font(.headline)
//                .fontWeight(.semibold)
//            
//            VStack(spacing: 12) {
//                ForEach(delivery.items) { item in
//                    HStack(spacing: 12) {
//                        if let image = item.image {
//                            Text(image)
//                                .font(.title2)
//                        } else {
//                            Image(systemName: "leaf.fill")
//                                .foregroundColor(.green)
//                                .font(.title3)
//                        }
//                        
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text(item.name)
//                                .font(.subheadline)
//                                .fontWeight(.medium)
//                            
//                            HStack {
//                                Text("\(item.quantity) \(item.unit)")
//                                    .font(.caption)
//                                    .foregroundColor(.secondary)
//                                
//                                if item.isOrganic {
//                                    Text("ORGANİK")
//                                        .font(.caption2)
//                                        .fontWeight(.bold)
//                                        .foregroundColor(.white)
//                                        .padding(.horizontal, 4)
//                                        .padding(.vertical, 1)
//                                        .background(Color.green)
//                                        .cornerRadius(3)
//                                }
//                            }
//                        }
//                        
//                        Spacer()
//                        
//                        Text("₺\(String(format: "%.2f", item.price))")
//                            .font(.subheadline)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.green)
//                    }
//                    .padding(.vertical, 8)
//                    
//                    if item.id != delivery.items.last?.id {
//                        Divider()
//                    }
//                }
//            }
//            .padding(15)
//            .background(Color(.systemGray6))
//            .cornerRadius(10)
//        }
//    }
//    
//    private func courierInfoSection(_ courierInfo: CourierInfo) -> some View {
//        VStack(alignment: .leading, spacing: 15) {
//            Text("Kurye Bilgileri")
//                .font(.headline)
//                .fontWeight(.semibold)
//            
//            HStack(spacing: 15) {
//                Image(systemName: "person.circle.fill")
//                    .font(.system(size: 50))
//                    .foregroundColor(.blue)
//                
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(courierInfo.name)
//                        .font(.subheadline)
//                        .fontWeight(.semibold)
//                    
//                    HStack(spacing: 4) {
//                        Image(systemName: "star.fill")
//                            .font(.caption)
//                            .foregroundColor(.yellow)
//                        Text(String(format: "%.1f", courierInfo.rating))
//                            .font(.caption)
//                            .fontWeight(.medium)
//                    }
//                    
//                    Text(courierInfo.vehicleType)
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
//                
//                Spacer()
//                
//                Button(action: {
//                    if let url = URL(string: "tel:\(courierInfo.phone)") {
//                        UIApplication.shared.open(url)
//                    }
//                }) {
//                    Image(systemName: "phone.fill")
//                        .font(.title3)
//                        .foregroundColor(.white)
//                        .frame(width: 40, height: 40)
//                        .background(Color.green)
//                        .cornerRadius(20)
//                }
//            }
//        }
//        .padding(20)
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
//    }
//    
//    private var actionButtonsSection: some View {
//        VStack(spacing: 12) {
//            if delivery.status == .preparing || delivery.status == .onWay {
//                Button(action: {
//                    Task {
//                        await viewModel.cancelDelivery(delivery)
//                        dismiss()
//                    }
//                }) {
//                    HStack {
//                        Image(systemName: "xmark.circle")
//                        Text("Teslimatı İptal Et")
//                    }
//                    .font(.subheadline)
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 12)
//                    .background(Color.red)
//                    .cornerRadius(10)
//                }
//            }
//            
//            if delivery.status == .delivered {
//                Button(action: {
//                    Task {
//                        await viewModel.reorderDelivery(delivery)
//                        dismiss()
//                    }
//                }) {
//                    HStack {
//                        Image(systemName: "arrow.clockwise")
//                        Text("Tekrar Sipariş Ver")
//                    }
//                    .font(.subheadline)
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 12)
//                    .background(Color.green)
//                    .cornerRadius(10)
//                }
//            }
//        }
//    }
//}
//
//
//struct DetailRowView: View {
//    let title: String
//    let value: String
//    
//    var body: some View {
//        HStack {
//            Text(title)
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//            Spacer()
//            Text(value)
//                .font(.subheadline)
//                .fontWeight(.medium)
//                .multilineTextAlignment(.trailing)
//        }
//    }
//}
//
//#Preview {
//    DeliveriesView()
//}
