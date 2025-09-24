//
//  ShopView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI
import Foundation

struct ShopView: View {
    
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject private var shopViewModel : ShopViewModel
    @EnvironmentObject private var cartViewModel : CartViewModel
    @EnvironmentObject private var recipeViewModel : RecipeViewModel

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 5) {
                    
                    quickActionsSection
                    
                    productCategoriesSection
                    productListSection
                    
                    recipeCategoriesSection
                    recipeListSection
                    
                    footerInfo
                }
            }
            .navigationTitle("Tünaydın")
            .background(Color(.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            .navigationSubtitleCompat("Hoşgeldiniz,\(userViewModel.user?.fullName ?? "")")
            .searchable(
                text: $shopViewModel.searchText,
                prompt: "Search for products"
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { shopViewModel.showScan.toggle() }) {
                        Image(systemName: "qrcode.viewfinder")
                            .foregroundColor(.primary)
                    }
                    .withHaptic()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        shopViewModel.toggleCart()
                    }) {
                        Image(systemName: "bag")
                            .foregroundColor(.primary)
                    }
                    .withHaptic(.medium)
                    .badge(cartViewModel.items.count)
                }
            }
            .sheet(isPresented: $shopViewModel.showScan) {
                ScanView()
            }
            .sheet(isPresented: $shopViewModel.showCart) {
                CartView()
            }
            .alert("Hata", isPresented: .constant(shopViewModel.errorMessage != nil)) {
                Button("Tamam") {
                    shopViewModel.errorMessage = nil
                }
            } message: {
                if let errorMessage = shopViewModel.errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }
    
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hızlı Erişim")
                .font(.system(size: 20, weight: .semibold))
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(shopViewModel.quickActions) { quickAction in
                        QuickActionCard(quickAction: quickAction)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 24)
    }
    
    private var productCategoriesSection: some View{
        CategoryScrollView(
            categories: shopViewModel.categories,
            selectedCategory: $shopViewModel.selectedCategory
        )
        .padding(.horizontal)
    }
    
    private var productListSection: some View{
        ScrollView(.horizontal){
            HStack{
                ForEach(
                    shopViewModel.filteredProducts(
                        category: shopViewModel.selectedCategory,
                        searchText: shopViewModel.searchText
                    ),
                    id:\.self
                ){ product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ProductCard(product: product){
                            cartViewModel.addItem(product: product)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical,10)
    }
    
    private var recipeCategoriesSection : some View {
        //TODO: kategori yapılacak
        Text("")
    }
    
    private var recipeListSection : some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(recipeViewModel.recipes){ recipe in
                    NavigationLink {
                        RecipeDetailView(recipe: recipe)
                    } label: {
                        RecipeCard(recipe: recipe)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical,10)
        }
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

#Preview{
    ShopView()
}
