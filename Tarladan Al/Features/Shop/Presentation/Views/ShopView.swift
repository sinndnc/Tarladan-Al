//
//  ShopView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI
import Foundation

struct ShopView: View {
    
    @StateObject private var viewModel = ShopViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Featured Banner
                    if viewModel.showFeaturedBanner {
                        featuredBanner
                    }
                    
                    // Quick Actions
                    quickActionsSection
                    
                    // Categories Grid
                    categoriesGrid
                    
                    // Footer Info
                    footerInfo
                }
            }
            .refreshable {
                viewModel.refreshData()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    headerSection
                }
                ToolbarItem(placement: .topBarTrailing) {
                    shopCardSection
                }
            }
            .sheet(isPresented: $viewModel.showCart) {
                CartView()
            }
            .overlay {
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .alert("Hata", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("Tamam") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }
    
    private var shopCardSection: some View {
        Button(action: {
            viewModel.toggleCart()
        }) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bag")
                    .foregroundColor(.primary)
                
                if viewModel.cartItemCount > 0 {
                    Text("\(viewModel.cartItemCount)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 18, height: 18)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 8, y: -8)
                }
            }
        }
        .withHaptic(.medium)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading) {
            Text("Tünaydın")
                .font(.headline)
                .fontWeight(.bold)
            Text("Hoşgeldiniz,\(userViewModel.user?.fullName ?? "")")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.gray)
        }
    }
    
    private var featuredBanner: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.featuredTitle)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text(viewModel.featuredDescription)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.9))
            
            Button(action: {
                // Handle featured banner action
            }) {
                Text("Keşfet")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.green)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(25)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.green, Color.green.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.top)
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hızlı Erişim")
                .font(.system(size: 20, weight: .semibold))
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.quickActions) { quickAction in
                        QuickActionCard(quickAction: quickAction)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 24)
    }
    
    private var categoriesGrid: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Kategoriler")
                .font(.system(size: 20, weight: .semibold))
                .padding(.horizontal, 20)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 16) {
                ForEach(viewModel.categories) { category in
                    NavigationLink {
                        CategoryProductsView(category: category)
                            .environmentObject(viewModel)
                    } label: {
                        CategoryCard(category: category)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 24)
    }
    
    private var footerInfo: some View {
        VStack(spacing: 20) {
            Divider()
                .padding(.horizontal, 20)
            
            VStack(spacing: 10) {
                FeatureRow(
                    icon: "🚚",
                    title: "Ücretsiz Teslimat",
                    subtitle: "₺100 ve üzeri siparişlerde"
                )
                
                FeatureRow(
                    icon: "🌱",
                    title: "%100 Organik Garanti",
                    subtitle: "Sertifikalı organik ürünler"
                )
                
                FeatureRow(
                    icon: "🔄",
                    title: "Kolay İade",
                    subtitle: "Memnun değilseniz 7 gün içinde"
                )
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 24)
    }
}

// MARK: - Category Card Component

struct CategoryCard: View {
    let category: Category
    
    var body: some View {
        VStack(spacing: 16) {
            // Category Header
            HStack {
                ZStack(alignment: .topTrailing) {
                    if category.isNew {
                        Text("YENİ")
                            .zIndex(1)
                            .padding(4)
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.displayName)
                            .lineLimit(2)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        Text(category.description)
                            .lineLimit(2)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                Text(category.icon)
                    .font(.system(size: 40))
            }
            
            // Product Count and Seasonal Badge
            HStack {
                Text("\(category.productCount) ürün")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(category.color)
                
                Spacer()
                
                if category.isSeasonal {
                    HStack(spacing: 4) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.green)
                        Text("Mevsimsel")
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .frame(height: 150)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(category.color.opacity(0.2), lineWidth: 1)
        )
    }
}

struct QuickAction: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
}

struct QuickActionCard: View {
    let quickAction: QuickAction
    
    var body: some View {
        Button(action: quickAction.action) {
            VStack(spacing: 12) {
                Image(systemName: quickAction.icon)
                    .font(.system(size: 24))
                    .foregroundColor(quickAction.color)
                    .frame(width: 50, height: 50)
                    .background(quickAction.color.opacity(0.15))
                    .clipShape(Circle())
                
                VStack(spacing: 4) {
                    Text(quickAction.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(quickAction.subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 120)
            .padding(.vertical, 16)
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Feature Row Component

struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(icon) \(title)")
                    .font(.caption)
                    .fontWeight(.medium)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}

// MARK: - Category Products View

struct CategoryProductsView: View {
    
    let category: Category
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: CategoryProductsViewModel
    @EnvironmentObject private var shopViewModel: ShopViewModel
    
    init(category: Category) {
        self.category = category
        self._viewModel = StateObject(wrappedValue: CategoryProductsViewModel(category: category))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                categoryInfoBanner
                
                // Subcategories
                subcategoriesBar
                
                // Sort and View Mode
                sortAndViewBar
                
                // Products
                productsSection
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        VStack(alignment: .leading) {
                            Text(category.displayName)
                                .font(.headline)
                            Text("\(viewModel.products.count) ürün mevcut")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.toggleFilters()
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
        }
        .sheet(isPresented: $viewModel.showFilters) {
            CategoryFiltersSheet(viewModel: viewModel)
        }
        .refreshable {
            viewModel.refreshProducts()
        }
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            }
        }
    }
    
    private var categoryInfoBanner: some View {
        HStack(spacing: 16) {
            Text(category.icon)
                .font(.system(size: 50))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(category.description)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                if category.isSeasonal {
                    HStack(spacing: 4) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                        Text("Mevsimsel özel ürünler")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "truck.box")
                            .font(.system(size: 12))
                            .foregroundColor(.blue)
                        Text("Hızlı teslimat")
                            .font(.system(size: 12))
                            .foregroundColor(.blue)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "leaf")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                        Text("Organik garanti")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                    }
                }
            }
            
            Spacer()
        }
        .padding(20)
        .background(category.color.opacity(0.1))
        .cornerRadius(16)
        .padding(.horizontal, 20)
    }
    
    private var subcategoriesBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.subcategories, id: \.self) { subcategory in
                    Button(action: {
                        viewModel.selectSubcategory(subcategory)
                    }) {
                        Text(subcategory)
                            .font(.system(size: 14, weight: .medium))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(viewModel.selectedSubcategory == subcategory ? category.color : Color(.systemGray6))
                            .foregroundColor(viewModel.selectedSubcategory == subcategory ? .white : .primary)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
    
    private var sortAndViewBar: some View {
        HStack {
            Text("Sıralama: ")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Text(viewModel.sortOption.rawValue)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(category.color)
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    viewModel.setViewMode(.grid)
                }) {
                    Image(systemName: "square.grid.2x2")
                        .foregroundColor(viewModel.viewMode == .grid ? category.color : .gray)
                }
                
                Button(action: {
                    viewModel.setViewMode(.list)
                }) {
                    Image(systemName: "list.bullet")
                        .foregroundColor(viewModel.viewMode == .list ? category.color : .gray)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var productsSection: some View {
        Group {
            if viewModel.viewMode == .grid {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 16) {
                    ForEach(viewModel.filteredProducts) { product in
                        EnhancedProductCard(
                            product: product,
                            accentColor: category.color,
                            onAddToCart: {
                                viewModel.addToCart(product)
                                shopViewModel.addToCart(product: product)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredProducts) { product in
                        EnhancedProductListRow(
                            product: product,
                            accentColor: category.color,
                            onAddToCart: {
                                viewModel.addToCart(product)
                                shopViewModel.addToCart(product: product)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Enhanced Product Components

struct EnhancedProductCard: View {
    let product: Product
    let accentColor: Color
    let onAddToCart: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Product Image with badges
            ZStack(alignment: .topTrailing) {
                Text(product.image)
                    .font(.system(size: 60))
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                
                VStack(spacing: 4) {
                    if product.isOnSale {
                        Text("İNDİRİM")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red)
                            .cornerRadius(4)
                    }
                    
                    if product.isOrganic {
                        Text("ORGANİK")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green)
                            .cornerRadius(4)
                    }
                }
                .offset(x: -8, y: 8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                // Product name and rating
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 4) {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", product.rating))
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                        
                        Text("(\(product.reviewCount))")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        // Stock status
                        HStack(spacing: 4) {
                            Circle()
                                .fill(product.stockStatus.color)
                                .frame(width: 6, height: 6)
                            Text(product.stockStatus.text)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(product.stockStatus.color)
                        }
                    }
                }
                
                // Origin and nutrition highlights
                VStack(alignment: .leading, spacing: 4) {
                    Text("Menşei: \(product.origin)")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    
                    if !product.nutritionHighlights.isEmpty {
                        Text("💪 \(product.nutritionHighlights.joined(separator: ", "))")
                            .font(.system(size: 11))
                            .foregroundColor(accentColor)
                            .lineLimit(1)
                    }
                }
                
                // Price section
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        if let originalPrice = product.originalPrice {
                            Text("₺\(originalPrice, specifier: "%.2f")")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                                .strikethrough()
                        }
                        
                        Text("₺\(product.price, specifier: "%.2f")")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(product.isOnSale ? .red : accentColor)
                    }
                    
                    Spacer()
                    
                    // Add to cart button
                    Button(action: onAddToCart) {
                        Image(systemName: product.stockStatus == .outOfStock ? "xmark" : "plus")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(product.stockStatus == .outOfStock ? Color.gray : accentColor)
                            .cornerRadius(8)
                    }
                    .disabled(product.stockStatus == .outOfStock)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

struct EnhancedProductListRow: View {
    let product: Product
    let accentColor: Color
    let onAddToCart: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Product image
            ZStack(alignment: .topLeading) {
                Text(product.image)
                    .font(.system(size: 50))
                    .frame(width: 90, height: 90)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                
                VStack(spacing: 2) {
                    if product.isOnSale {
                        Text("İNDİRİM")
                            .font(.system(size: 7, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.red)
                            .cornerRadius(3)
                    }
                    
                    if product.isOrganic {
                        Text("ORGANİK")
                            .font(.system(size: 7, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.green)
                            .cornerRadius(3)
                    }
                }
                .offset(x: 4, y: 4)
            }
            
            // Product details
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)
                
                Text(product.description)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    // Rating
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", product.rating))
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                    
                    // Origin
                    Text("📍 \(product.origin)")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                // Nutrition highlights
                if !product.nutritionHighlights.isEmpty {
                    Text("💪 \(product.nutritionHighlights.prefix(2).joined(separator: ", "))")
                        .font(.system(size: 10))
                        .foregroundColor(accentColor)
                        .lineLimit(1)
                }
                
                // Stock and price
                HStack {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(product.stockStatus.color)
                            .frame(width: 6, height: 6)
                        Text(product.stockStatus.text)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(product.stockStatus.color)
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
                            .foregroundColor(product.isOnSale ? .red : accentColor)
                    }
                }
            }
            
            // Add to cart button
            Button(action: onAddToCart) {
                Image(systemName: product.stockStatus == .outOfStock ? "xmark" : "plus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(product.stockStatus == .outOfStock ? Color.gray : accentColor)
                    .cornerRadius(12)
            }
            .disabled(product.stockStatus == .outOfStock)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Category Filters Sheet

struct CategoryFiltersSheet: View {
    @ObservedObject var viewModel: CategoryProductsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sıralama Seçenekleri")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 12) {
                        ForEach(viewModel.sortOptions, id: \.self) { option in
                            Button(action: {
                                viewModel.updateSortOption(option)
                            }) {
                                HStack {
                                    Text(option.rawValue)
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
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(20)
            .navigationTitle("Filtreler")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Uygula") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                }
            }
        }
    }
}


struct CartView: View {
    @StateObject private var viewModel = CartViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Cart implementation
                Text("Sepet sayfası")
                    .font(.title)
            }
            .navigationTitle("Sepetim")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview{
    ShopView()
}
