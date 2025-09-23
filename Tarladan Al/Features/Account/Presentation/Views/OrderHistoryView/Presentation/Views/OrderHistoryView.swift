//
//  OrderHistoryView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//
import SwiftUI
import FirebaseFirestore

struct OrderHistoryView: View {
    
    @State private var searchText = ""
    @State private var showingOrderDetail: Order? = nil
    @State private var selectedFilter: OrderStatus? = nil
    
    @EnvironmentObject private var orderViewModel: OrderViewModel
    
    private var filteredOrders: [Order] {
        var filtered = orderViewModel.orders
        
        if let selectedFilter = selectedFilter {
            filtered = filtered.filter { $0.status == selectedFilter }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { order in
                order.orderNumber.localizedCaseInsensitiveContains(searchText) ||
                order.items.contains { $0.product.title.localizedCaseInsensitiveContains(searchText) } ||
                order.items.contains { $0.product.farmerName.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        return filtered.sorted { $0.orderDate > $1.orderDate }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter Chips
            filterSection
            
            // Orders List
            ordersList
        }
        .navigationTitle("Sipariş Geçmişi")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(
            text: $searchText,
            prompt: "Search for products"
        )
        .sheet(item: $showingOrderDetail) { order in
            OrderDetailView(order: order)
        }
    }
    
    // MARK: - Filter Section
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Tümü butonu
                FilterChip(
                    title: "Tümü",
                    isSelected: selectedFilter == nil,
                    count: orderViewModel.orders.count
                ) {
                    withAnimation{
                        selectedFilter = nil
                    }
                }
                // Status filter'ları
                ForEach(OrderStatus.allCases, id: \.self) { status in
                    let count = orderViewModel.orders.filter { $0.status == status }.count
                    if count > 0 {
                        FilterChip(
                            title: status.rawValue,
                            isSelected: selectedFilter == status,
                            count: count
                        ) {
                            withAnimation{
                                selectedFilter = selectedFilter == status ? nil : status
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Orders List
    private var ordersList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if filteredOrders.isEmpty {
                    emptyState
                } else {
                    ForEach(filteredOrders) { order in
                        OrderCard(order: order) {
                            showingOrderDetail = order
                        }
                    }
                }
            }
            .padding()
        }
        .background(Colors.System.background)
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bag")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Sipariş bulunamadı")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Aradığınız kriterlere uygun sipariş bulunmuyor.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

