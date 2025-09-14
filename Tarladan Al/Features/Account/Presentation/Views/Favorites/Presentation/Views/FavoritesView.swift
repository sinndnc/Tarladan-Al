//
//  FavoritesView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//
import SwiftUI

struct FavoritesView: View {
    
    @State private var searchText = ""
    @State private var selectedCategory = "Tümü"
    @State private var showingGrid = false
    @State private var showingProductDetail: Product? = nil
    
    @EnvironmentObject private var userViewModel: UserViewModel
    
    private let categories = [
        "Tümü", "Meyveler", "Sebzeler", "Tahıllar & Baklagiller",
        "Süt Ürünleri Ürünleri","Et & Su Ürünleri","Bal & Arıcılık",
        "Baharat & Çeşniler","Kuru Meyve & Kuruyemiş","Zeytin & Zeytinyağı",
        "İçecekler & Şıra","Mantarlar","Çiçek & Süs Bitkileri", "Tıbbi & Aromatik Bitkiler"
    ]
    
    private var filteredProducts: [Product] {
        var filtered = userViewModel.user?.favorites ?? []
        
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
        
        return filtered
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Category Filter
            categoryFilterSection
            
            // View Toggle
            viewToggleSection
            
            // Products
            if filteredProducts.isEmpty {
                emptyStateView
            } else {
                productsSection
            }
        }
        .navigationTitle("Favorilerim")
        .toolbarTitleDisplayMode(.inline)
        .background(Colors.System.background)
        .toolbarColorScheme(.dark, for:.navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Colors.UI.tabBackground, for: .navigationBar)
        .searchable(text: .constant(""), prompt: "Search products")
        .sheet(item: $showingProductDetail) { product in
            ProductDetailView(product: product)
        }
    }
    
    
    // MARK: - Category Filter
    private var categoryFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories,id:\.self){ category in
                    if let user = userViewModel.user{
                        let count = category == "Tümü" ?
                        user.favorites.count :
                        user.favorites.filter { $0.categoryName == category }.count
                        
                        CategoryChip(
                            title: category,
                            count: count,
                            isSelected: selectedCategory == category,
                            showZeroCount: true
                        ) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Colors.UI.tabBackground)
    }
    
    // MARK: - View Toggle
    private var viewToggleSection: some View {
        VStack{
            HStack {
                Text("\(filteredProducts.count) favori ürün")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
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
            .padding(.vertical,10)
            Divider()
        }
        .background(Colors.UI.tabBackground)
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
            ForEach(filteredProducts,id:\.id) { product in
                ProductGridCard(product: product) {
                    showingProductDetail = product
                }
            }
        }
        .padding()
    }
    
    // MARK: - List Layout
    private var listLayout: some View {
        LazyVStack(spacing: 12) {
            ForEach(filteredProducts,id:\.id) { product in
                ProductCard(product: product) {
                    showingProductDetail = product
                }
            }
        }
        .padding()
    }
}
