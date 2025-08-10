//
//  SearchView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var showCart = false
    @State private var cartItemCount = 3
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                if viewModel.showRecentSearches {
                    recentSearchesWidget
                }
                
                // İstatistik widget
                if viewModel.shouldShowStats {
                    searchStatsWidget
                }
                
                if viewModel.isLoading {
                    loadingView
                } else if viewModel.isEmpty {
                    emptyStateView
                } else {
                    productListView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText,isPresented: $viewModel.isShowingSearchable, prompt: "Search for products")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading) {
                        Text("Search")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Everything You Need")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { }) {
                        Image(systemName: "qrcode.viewfinder")
                            .foregroundColor(.primary)
                    }
                    .withHaptic()
                }
            }
            .sheet(isPresented: $viewModel.showFilters) {
                FilterSheet(viewModel: viewModel)
            }
        }
    }
    
    private var recentSearchesWidget: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Son Aramalar")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button("Temizle") {
                    viewModel.clearRecentSearches()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            FlowLayout {
                ForEach(viewModel.recentSearches, id: \.self) { search in
                    Button(action: {
                        viewModel.selectRecentSearch(search)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 12))
                            Text(search)
                                .font(.system(size: 14))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray6))
                        .foregroundColor(.primary)
                        .cornerRadius(16)
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .border(Color(.systemGray5), width: 0.5)
    }
    
    private var searchStatsWidget: some View {
        HStack {
            Text(viewModel.searchStats)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Active filter chips
            ForEach(viewModel.getActiveFilterChips(), id: \.self) { chip in
                Button(action: {
                    viewModel.removeFilterChip(chip)
                }) {
                    HStack(spacing: 4) {
                        Text(chip)
                            .font(.system(size: 12, weight: .medium))
                        Image(systemName: "xmark")
                            .font(.system(size: 10))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(.systemGray6).opacity(0.5))
    }
    
    private var filterAndViewModeBar: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        FilterChip(
                            title: category,
                            isSelected: viewModel.selectedCategory == category
                        ) {
                            viewModel.selectCategory(category)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            
            Spacer()
            
            // View mode toggle
            HStack(spacing: 8) {
                Button(action: {
                    viewModel.viewMode = .grid
                }) {
                    Image(systemName: "square.grid.2x2")
                        .foregroundColor(viewModel.viewMode == .grid ? .green : .gray)
                }
                
                Button(action: {
                    viewModel.viewMode = .list
                }) {
                    Image(systemName: "list.bullet")
                        .foregroundColor(viewModel.viewMode == .list ? .green : .gray)
                }
                
                Button(action: {
                    viewModel.showFilters = true
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.gray)
                }
            }
            .padding(.trailing, 16)
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
    
    private var productListView: some View {
        ScrollView(showsIndicators: false) {
            filterAndViewModeBar
            
            if viewModel.viewMode == .grid {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ], spacing: 16) {
                    ForEach(viewModel.filteredProducts) { product in
                        ProductCard(product: product)
                    }
                }
                .padding(.horizontal, 16)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredProducts) { product in
                        ProductListRow(product: product)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .refreshable {
            viewModel.refreshProducts()
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Ürünler yükleniyor...")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Sonuç bulunamadı")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Arama teriminizi değiştirmeyi veya filtreleri temizlemeyi deneyin")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button("Filtreleri Temizle") {
                viewModel.clearAllFilters()
            }
            .foregroundColor(.green)
            .font(.system(size: 16, weight: .medium))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

// MARK: - Widget Components
struct FlowLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var point = bounds.origin
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        for (index, subview) in subviews.enumerated() {
            let size = sizes[index]
            
            if point.x + size.width > bounds.maxX {
                point.x = bounds.origin.x
                point.y += size.height + 8
            }
            
            subview.place(at: point, proposal: ProposedViewSize(size))
            point.x += size.width + 8
        }
    }
}

// MARK: - Enhanced Components

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.green : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                // Ürün resmi
                Text(product.image)
                    .font(.system(size: 50))
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                // İndirim badge
                if product.isOnSale {
                    Text("İNDİRİM")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .cornerRadius(4)
                        .offset(x: -4, y: 4)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // Organik badge ve mevsimsellik
                HStack {
                    if product.isOrganic {
                        Text("ORGANİK")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.green)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(3)
                    }
                    
                    if let seasonality = product.seasonality {
                        Text(seasonality)
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.orange)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(3)
                    }
                    
                    Spacer()
                }
                
                // Ürün adı
                Text(product.name)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Rating
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", product.rating))
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Text("(\(product.reviewCount))")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
                
                // Fiyat
                HStack {
                    if let originalPrice = product.originalPrice {
                        Text("₺\(originalPrice, specifier: "%.2f")")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .strikethrough()
                    }
                    
                    Text("₺\(product.price, specifier: "%.2f")")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(product.isOnSale ? .red : .green)
                }
                
                // Stok durumu
                HStack {
                    Circle()
                        .fill(product.stockStatus.color)
                        .frame(width: 6, height: 6)
                    Text(product.stockStatus.text)
                        .font(.system(size: 10))
                        .foregroundColor(product.stockStatus.color)
                    Spacer()
                }
            }
            
            // Sepete ekle butonu
            Button(action: {
                // Sepete ekleme işlemi
            }) {
                Text(product.stockStatus == .outOfStock ? "Tükendi" : "Sepete Ekle")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(product.stockStatus == .outOfStock ? Color.gray : Color.green)
                    .cornerRadius(8)
            }
            .disabled(product.stockStatus == .outOfStock)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct ProductListRow: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 12) {
            // Ürün resmi
            ZStack(alignment: .topLeading) {
                Text(product.image)
                    .font(.system(size: 40))
                    .frame(width: 80, height: 80)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                if product.isOnSale {
                    Text("İNDİRİM")
                        .font(.system(size: 7, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(Color.red)
                        .cornerRadius(3)
                        .offset(x: 2, y: 2)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    if product.isOrganic {
                        Text("ORGANİK")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.green)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(3)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Circle()
                            .fill(product.stockStatus.color)
                            .frame(width: 6, height: 6)
                        Text(product.stockStatus.text)
                            .font(.system(size: 10))
                            .foregroundColor(product.stockStatus.color)
                    }
                }
                
                Text(product.name)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)
                
                Text(product.description)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", product.rating))
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        Text("(\(product.reviewCount))")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        if let originalPrice = product.originalPrice {
                            Text("₺\(originalPrice, specifier: "%.2f")")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                                .strikethrough()
                        }
                        
                        Text("₺\(product.price, specifier: "%.2f")")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(product.isOnSale ? .red : .green)
                    }
                }
            }
            
            Button(action: {
                // Sepete ekleme işlemi
            }) {
                Image(systemName: product.stockStatus == .outOfStock ? "xmark" : "plus")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(product.stockStatus == .outOfStock ? Color.gray : Color.green)
                    .cornerRadius(8)
            }
            .disabled(product.stockStatus == .outOfStock)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct FilterSheet: View {
    @ObservedObject var viewModel: SearchViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Kategori")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Button(action: {
                                viewModel.selectCategory(category)
                            }) {
                                Text(category)
                                    .font(.system(size: 14))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(viewModel.selectedCategory == category ? Color.green : Color(.systemGray6))
                                    .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Sıralama")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 8) {
                        ForEach(viewModel.sortOptions, id: \.self) { option in
                            Button(action: {
                                viewModel.selectSortOption(option)
                            }) {
                                HStack {
                                    Text(option)
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    if viewModel.sortOption == option {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.green)
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(20)
            .navigationTitle("Filtreler")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("İptal") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Uygula") {
                    presentationMode.wrappedValue.dismiss()
                }
                .fontWeight(.semibold)
                .foregroundColor(.green)
            )
        }
    }
}
#Preview{
    SearchView()
}
