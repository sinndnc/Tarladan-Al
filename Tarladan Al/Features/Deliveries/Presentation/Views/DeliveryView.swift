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
            ScrollView(showsIndicators: false){
                VStack(spacing: 20){
                    if let currentDelivery = deliveryViewModel.currentDelivery {
                        DeliveryStatusCard(delivery: currentDelivery)
                    }
                    
                    DeliveryMapCard()
                    
                    NextDeliveryCard()
                    
                    WeeklyScheduleCard()
                    
                    activeDeliveriesView
                    
                    deliveryHistoryView
                    
                    deliveryPreferenecesView
                }
            }
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .navigationTitle(Text("Teslimatlar"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationSubtitleCompat("Hadi hemen kontrol et siparişlerini!")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack{
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .sheet(item: $selectedDelivery) { delivery in
            DeliveryDetailView(delivery: delivery)
        }
    }
    
    
    private var activeDeliveriesView: some View {
        VStack(alignment: .leading){
            Text("Aktif Teslimatlar")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
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
                .foregroundStyle(.secondary)
            
            ForEach(completedDeliveries) { delivery in
                DeliveryCard(delivery: delivery) {
                    selectedDelivery = delivery
                }
            }
        }
    }
    
    private var deliveryPreferenecesView: some View {
        VStack(alignment: .leading) {
            Text("Teslimat Tercihleri")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
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



#Preview {
    DeliveryView()
}
