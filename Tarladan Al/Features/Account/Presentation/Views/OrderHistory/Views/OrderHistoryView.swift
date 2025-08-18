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

// MARK: - Order Card
struct OrderCard: View {
    let order: Order
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(order.orderNumber)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(order.orderDate, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: order.status.icon)
                                .foregroundColor(order.status.color)
                                .font(.caption)
                            
                            Text(order.status.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(order.status.color)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(order.status.color.opacity(0.1))
                        .cornerRadius(8)
                        
                        Text("₺\(order.totalAmount, specifier: "%.2f")")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                }
                
                // Ürün Önizleme
                HStack(spacing: 8) {
                    ForEach(Array(order.items.prefix(3)), id: \.id) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            // Ürün görseli placeholder
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    VStack {
                                        Image(systemName: item.product.isOrganic ? "leaf.fill" : "photo")
                                            .foregroundColor(item.product.isOrganic ? .green : .gray)
                                            .font(.caption)
                                    }
                                )
                            
                            Text(item.product.title)
                                .font(.caption)
                                .lineLimit(2)
                                .frame(width: 50, alignment: .leading)
                        }
                    }
                    
                    if order.items.count > 3 {
                        VStack {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Text("+\(order.items.count - 3)")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.gray)
                                )
                            
                            Text("daha")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                
                // Alt Bilgiler
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Çiftçi: \(order.items.first?.product.farmerName ?? "")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if order.items.count > 1 {
                            Text("ve \(order.items.count - 1) çiftçi daha")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("\(Int(order.totalQuantity))")
                            .font(.caption)
                            .fontWeight(.medium)
                        Text("ürün")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Delivery Info
                if let deliveryDate = order.deliveryDate {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Text("Teslimat: \(deliveryDate, style: .date)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("• \(order.deliveryAddress.district), \(order.deliveryAddress.city)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("(\(count))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.blue : Color(.systemGray6))
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Order Detail View
struct OrderDetailView: View {
    let order: Order
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Order Header
                    orderHeaderSection
                    
                    // Status Timeline
                    statusTimelineSection
                    
                    // Items
                    orderItemsSection
                    
                    // Delivery Address
                    deliveryAddressSection
                    
                    // Price Breakdown
                    priceBreakdownSection
                }
                .padding()
            }
            .navigationTitle("Sipariş Detayı")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Kapat") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private var orderHeaderSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(order.orderNumber)
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Sipariş Tarihi: \(order.orderDate, style: .date)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: order.status.icon)
                    .foregroundColor(order.status.color)
                
                Text(order.status.rawValue)
                    .fontWeight(.medium)
                    .foregroundColor(order.status.color)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(order.status.color.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var statusTimelineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sipariş Durumu")
                .font(.headline)
            
            VStack(spacing: 16) {
                ForEach(OrderStatus.allCases, id: \.self) { status in
                    let isCompleted = statusIndex(status) <= statusIndex(order.status)
                    let isCurrent = status == order.status
                    
                    HStack {
                        Image(systemName: isCompleted ? status.icon : "circle")
                            .foregroundColor(isCompleted ? status.color : .gray)
                            .font(.title3)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(status.rawValue)
                                .fontWeight(isCurrent ? .semibold : .regular)
                                .foregroundColor(isCompleted ? .primary : .secondary)
                            
                            if isCurrent && order.deliveryDate != nil {
                                Text("Tahmini: \(order.deliveryDate!, style: .date)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var orderItemsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sipariş İçeriği")
                .font(.headline)
            
            ForEach(order.items) { item in
                HStack {
                    // Product Image Placeholder
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            VStack {
                                Image(systemName: item.product.isOrganic ? "leaf.fill" : "photo")
                                    .foregroundColor(item.product.isOrganic ? .green : .gray)
                            }
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.product.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("Çiftçi: \(item.product.farmerName)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            if item.product.isOrganic {
                                HStack(spacing: 2) {
                                    Image(systemName: "leaf.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                    Text("Organik")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                            
                            Text("\(item.quantity, specifier: "%.1f") \(item.product.unit)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("₺\(item.totalPrice, specifier: "%.2f")")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("₺\(item.unitPrice, specifier: "%.2f")/\(item.product.unit)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var deliveryAddressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Teslimat Adresi")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(order.deliveryAddress.title)
                    .fontWeight(.medium)
                
                Text(order.deliveryAddress.fullAddress)
                    .font(.subheadline)
                
                Text("\(order.deliveryAddress.district), \(order.deliveryAddress.city)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var priceBreakdownSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Ürün Toplamı")
                Spacer()
                Text("₺\(order.totalAmount - order.shippingCost, specifier: "%.2f")")
            }
            
            if order.shippingCost > 0 {
                HStack {
                    Text("Kargo")
                    Spacer()
                    Text("₺\(order.shippingCost, specifier: "%.2f")")
                }
            } else {
                HStack {
                    Text("Kargo")
                    Spacer()
                    Text("Ücretsiz")
                        .foregroundColor(.green)
                }
            }
            
            Divider()
            
            HStack {
                Text("Toplam")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("₺\(order.totalAmount, specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private func statusIndex(_ status: OrderStatus) -> Int {
        OrderStatus.allCases.firstIndex(of: status) ?? 0
    }
}

// MARK: - Preview
struct OrderHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistoryView()
    }
}
