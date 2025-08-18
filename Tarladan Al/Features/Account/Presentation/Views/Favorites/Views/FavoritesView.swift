//
//  FavoritesView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//
import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @State private var searchText = ""
    @State private var selectedCategory = "Tümü"
    @State private var showingGrid = false
    @State private var showingProductDetail: Product? = nil
    
    private let categories = ["Tümü", "Sebze", "Meyve", "Tahıl", "Süt Ürünleri"]
    
    private var filteredProducts: [Product] {
        var filtered = viewModel.favoriteProducts
        
        // Kategori filtresi
        if selectedCategory != "Tümü" {
            filtered = filtered.filter { $0.categoryName == selectedCategory }
        }
        
        // Arama filtresi
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                product.title.localizedCaseInsensitiveContains(searchText) ||
                product.farmerName.localizedCaseInsensitiveContains(searchText) ||
                product.locationName.localizedCaseInsensitiveContains(searchText) ||
                product.categoryName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.createdAt > $1.createdAt }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                searchSection
                
                // Category Filter
                categoryFilterSection
                
                // View Toggle
                viewToggleSection
                
                // Products
                if viewModel.isLoading {
                    loadingView
                } else if filteredProducts.isEmpty {
                    emptyStateView
                } else {
                    productsSection
                }
            }
            .navigationTitle("Favorilerim")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadFavorites()
            }
            .sheet(item: $showingProductDetail) { product in
                ProductDetailView(product: product)
            }
        }
    }
    
    // MARK: - Search Section
    private var searchSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Ürün, çiftçi veya konum ara...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !searchText.isEmpty {
                Button("Temizle") {
                    searchText = ""
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    // MARK: - Category Filter
    private var categoryFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories,id:\.self){ category in
                    let count = category == "Tümü" ?
                        viewModel.favoriteProducts.count :
                        viewModel.favoriteProducts.filter { $0.categoryName == category }.count
                    
                    if count > 0 || category == "Tümü" {
                        CategoryChip(
                            title: category,
                            count: count,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - View Toggle
    private var viewToggleSection: some View {
        HStack {
            Text("\(filteredProducts.count) favori ürün")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: { showingGrid = false }) {
                    Image(systemName: "list.bullet")
                        .foregroundColor(showingGrid ? .gray : .blue)
                        .font(.title3)
                }
                
                Button(action: { showingGrid = true }) {
                    Image(systemName: "square.grid.2x2")
                        .foregroundColor(showingGrid ? .blue : .gray)
                        .font(.title3)
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Favoriler yükleniyor...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Favori ürün bulunamadı")
                .font(.title2)
                .fontWeight(.semibold)
            
            if !searchText.isEmpty || selectedCategory != "Tümü" {
                Text("Filtreleri temizleyerek tüm favorilerinizi görebilirsiniz.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Button("Filtreleri Temizle") {
                    searchText = ""
                    selectedCategory = "Tümü"
                }
                .foregroundColor(.blue)
            } else {
                Text("Henüz hiç ürün favorilemediniz.\nBeğendiğiniz ürünleri kalp simgesine tıklayarak favorilerinize ekleyebilirsiniz.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    // MARK: - Products Section
    private var productsSection: some View {
        ScrollView {
            if showingGrid {
                gridLayout
            } else {
                listLayout
            }
        }
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Grid Layout
    private var gridLayout: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 16) {
            ForEach(filteredProducts) { product in
                ProductGridCard(product: product, viewModel: viewModel) {
                    showingProductDetail = product
                }
            }
        }
        .padding()
    }
    
    // MARK: - List Layout
    private var listLayout: some View {
        LazyVStack(spacing: 12) {
            ForEach(filteredProducts) { product in
                ProductListCard(product: product, viewModel: viewModel) {
                    showingProductDetail = product
                }
            }
        }
        .padding()
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if count > 0 {
                    Text("(\(count))")
                        .font(.caption)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                }
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

// MARK: - Product Grid Card
struct ProductGridCard: View {
    let product: Product
    @ObservedObject var viewModel: FavoritesViewModel
    let onTap: () -> Void
    @State private var showingAddedToCart = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Product Image
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 120)
                        .overlay(
                            VStack {
                                if product.isOrganic {
                                    Image(systemName: "leaf.fill")
                                        .foregroundColor(.green)
                                        .font(.title)
                                } else {
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                        .font(.title)
                                }
                            }
                        )
                    
                    // Favorite Button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.toggleFavorite(product)
                        }
                    }) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                            .padding(8)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                    }
                    .padding(8)
                }
                
                // Product Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                    
                    Text(product.farmerName)
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text(product.locationName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        if product.isOrganic {
                            HStack(spacing: 2) {
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(.green)
                                    .font(.caption)
                                Text("Organik")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Spacer()
                        
                        Text("₺\(product.price, specifier: "%.0f")/\(product.unit)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                }
                
                // Add to Cart Button
                Button(action: addToCart) {
                    HStack {
                        Image(systemName: showingAddedToCart ? "checkmark" : "cart.badge.plus")
                            .font(.caption)
                        
                        Text(showingAddedToCart ? "Eklendi" : "Sepete Ekle")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(showingAddedToCart ? Color.green : Color.blue)
                    .cornerRadius(8)
                }
                .disabled(showingAddedToCart)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    private func addToCart() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showingAddedToCart = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingAddedToCart = false
            }
        }
    }
}

// MARK: - Product List Card
struct ProductListCard: View {
    let product: Product
    @ObservedObject var viewModel: FavoritesViewModel
    let onTap: () -> Void
    @State private var showingAddedToCart = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Product Image
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .overlay(
                            VStack {
                                if product.isOrganic {
                                    Image(systemName: "leaf.fill")
                                        .foregroundColor(.green)
                                        .font(.title2)
                                } else {
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                        .font(.title2)
                                }
                            }
                        )
                }
                
                // Product Details
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(product.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.toggleFavorite(product)
                            }
                        }) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .font(.title3)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Text(product.farmerName)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.gray)
                            .font(.caption)
                        
                        Text(product.locationName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if product.isOrganic {
                            HStack(spacing: 2) {
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(.green)
                                    .font(.caption)
                                Text("Organik")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    HStack {
                        Text("₺\(product.price, specifier: "%.0f")/\(product.unit)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("• \(product.quantity, specifier: "%.0f") \(product.unit) stok")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button(action: addToCart) {
                            Image(systemName: showingAddedToCart ? "checkmark.circle.fill" : "cart.badge.plus")
                                .foregroundColor(showingAddedToCart ? .green : .blue)
                                .font(.title2)
                        }
                        .disabled(showingAddedToCart)
                    }
                }
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    private func addToCart() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showingAddedToCart = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingAddedToCart = false
            }
        }
    }
}
