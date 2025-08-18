//
//  OrderHistoryView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//
import SwiftUI
import FirebaseFirestore

struct OrderHistoryView: View {
    @State private var orders: [Order] = []
    @State private var selectedFilter: OrderStatus? = nil
    @State private var searchText = ""
    @State private var showingOrderDetail: Order? = nil
    
    private var filteredOrders: [Order] {
        var filtered = orders
        
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
            // Search Bar
            searchSection
            
            // Filter Chips
            filterSection
            
            // Orders List
            ordersList
        }
        .navigationTitle("Sipariş Geçmişi")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadSampleOrders()
        }
        .sheet(item: $showingOrderDetail) { order in
            OrderDetailView(order: order)
        }
    }
    
    // MARK: - Search Section
    private var searchSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Sipariş no, ürün veya çiftçi ara...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    // MARK: - Filter Section
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Tümü butonu
                FilterChip(
                    title: "Tümü",
                    isSelected: selectedFilter == nil,
                    count: orders.count
                ) {
                    selectedFilter = nil
                }
                
                // Status filter'ları
                ForEach(OrderStatus.allCases, id: \.self) { status in
                    let count = orders.filter { $0.status == status }.count
                    if count > 0 {
                        FilterChip(
                            title: status.rawValue,
                            isSelected: selectedFilter == status,
                            count: count
                        ) {
                            selectedFilter = selectedFilter == status ? nil : status
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
        .background(Color(.systemGroupedBackground))
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
    
    // MARK: - Sample Data
    private func loadSampleOrders() {
        let sampleProducts = [
            Product(
                id: "1",
                farmerId: "farmer1",
                farmerName: "Ahmet Demir",
                farmerPhone: "+90 555 123 4567",
                categoryName: "Sebze",
                subCategoryName: "Yaprak Sebze",
                title: "Organik Ispanak",
                description: "Taze ve organik ıspanak",
                price: 25.0,
                unit: "kg",
                quantity: 10.0,
                images: ["ispanak1", "ispanak2"],
                location: GeoPoint(latitude: 24.1231, longitude: 14.14234),
                locationName: "Bursa, Nilüfer",
                createdAt: Date(),
                updatedAt: Date(),
                isActive: true,
                isOrganic: true,
                harvestDate: Date(),
                expiryDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())
            ),
            Product(
                id: "2",
                farmerId: "farmer2",
                farmerName: "Fatma Kaya",
                farmerPhone: "+90 555 987 6543",
                categoryName: "Meyve",
                subCategoryName: "Turunçgiller",
                title: "Portakal",
                description: "Antalya'dan taze portakal",
                price: 12.0,
                unit: "kg",
                quantity: 20.0,
                images: ["portakal1"],
                location: GeoPoint(latitude: 24.1231, longitude: 14.14234),
                locationName: "Antalya, Finike",
                createdAt: Date(),
                updatedAt: Date(),
                isActive: true,
                isOrganic: false,
                harvestDate: Date(),
                expiryDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())
            )
        ]
        
        let sampleAddress = Address(
            title: "Ev",
            fullAddress: "Atatürk Mahallesi, Cumhuriyet Caddesi No: 45/7",
            city: "İstanbul",
            district: "Kadıköy",
            isDefault: true
        )
        
        orders = [
            Order(
                orderNumber: "ORD-2025-001",
                items: [
                    OrderItem(product: sampleProducts[0], quantity: 2.0, unitPrice: 25.0),
                    OrderItem(product: sampleProducts[1], quantity: 5.0, unitPrice: 12.0)
                ],
                orderDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                deliveryDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
                status: .shipping,
                deliveryAddress: sampleAddress,
                totalAmount: 110.0,
                shippingCost: 0.0
            ),
            Order(
                orderNumber: "ORD-2025-002",
                items: [OrderItem(product: sampleProducts[1], quantity: 3.0, unitPrice: 12.0)],
                orderDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
                deliveryDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()),
                status: .delivered,
                deliveryAddress: sampleAddress,
                totalAmount: 36.0,
                shippingCost: 0.0
            ),
            Order(
                orderNumber: "ORD-2025-003",
                items: [OrderItem(product: sampleProducts[0], quantity: 1.0, unitPrice: 25.0)],
                orderDate: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date(),
                deliveryDate: nil,
                status: .cancelled,
                deliveryAddress: sampleAddress,
                totalAmount: 25.0,
                shippingCost: 0.0
            )
        ]
    }
}

