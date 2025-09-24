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
            List{
                if let currentDelivery = deliveryViewModel.currentDelivery {
                    DeliveryStatusCard(delivery: currentDelivery)
                }
                
                Section{
                    DeliveryMapCard()
                }
                
                Section{
                    NextDeliveryCard()
                }
                
                Section{
                    WeeklyScheduleCard()
                }
                
                activeDeliveriesView
                
                deliveryHistoryView
                
                deliveryPreferenecesView
            }
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
        Section{
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
    }
    
    private var deliveryHistoryView: some View {
        Section{
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
    }
    
    private var deliveryPreferenecesView: some View {
        Section{
            VStack(alignment: .leading, spacing: 15) {
                Text("Teslimat Tercihleri")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                DeliveryPreferencesCard()
            }
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
