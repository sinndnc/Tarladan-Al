//
//  HomeView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI

struct HomeView: View {
    
    @StateObject private var homeViewModel = HomeViewModel()
    
    @EnvironmentObject private var rootViewModel: RootViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject private var shopViewModel: ShopViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var recipeViewModel: RecipeViewModel
    @EnvironmentObject private var productViewModel: ProductViewModel
    @EnvironmentObject private var deliveryViewModel: DeliveryViewModel
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    if let delivery = deliveryViewModel.currentDelivery {
                        DeliveryStatusCard(delivery:delivery)
                    }
                    
                    if let banner = homeViewModel.featuredBanner {
                        featuredBanner(banner)
                    }
                    
                    quickActionsSection
                    
                    categoriesSection
                    
                    seasonalHighlightsSection
                    
                    recipesSection
                }
                .padding(.horizontal)
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    headerSection
                }
                ToolbarItem(placement: .topBarTrailing) {
                    tralingSection
                }
            }
            .refreshable {}
            .sheet(isPresented: $homeViewModel.showingLocation) {
                if let user =  userViewModel.user {
                    LocationPickerView(addresses: user.addresses)
                }
            }
            .alert("Hata", isPresented: $homeViewModel.showingError) {
                Button("Tamam"){
                    
                }
            } message: {
                if let errorMessage = homeViewModel.errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }
    
    //MARK: - Trailing Section
    private var headerSection: some View {
        VStack(alignment: .leading,spacing: 0) {
            Text("Teslimat Adresi")
                .font(.headline)
                .fontWeight(.bold)
            
            Button {
                homeViewModel.showingLocation = true
            }label: {
                if let user = userViewModel.user,
                let defaultAddress = user.defaultAddress{
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption2)
                            .foregroundColor(.blue)
                        Text("\(defaultAddress.fullAddress)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .tint(.black)
            .withHaptic(.medium)
        }
    }
    
    //MARK: - Trailing Section
    private var tralingSection: some View {
        NavigationLink {
            NotificationView()
        } label: {
            Image(systemName: "bell")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .haptic()
    }
    
    // MARK: - Featured Banner
    private func featuredBanner(_ banner: Banner) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(banner.title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text(banner.subtitle)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    if let discountText = banner.discountText {
                        Text(discountText)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.yellow)
                    }
                    
                    Button(banner.buttonText) {
//                        viewModel.purchaseFeaturedOffer()
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                }
                
                Spacer()
                
                Image(systemName: "leaf.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.3))
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.green, Color.green.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Hızlı Erişim")
                    .font(.headline)
                    .fontWeight(.semibold)
                    
                Spacer()
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    NavigationLink {
                        OrderHistoryView()
                    } label: {
                        QuickActionCard(
                            quickAction: QuickAction(
                                icon: "clock.arrow.circlepath",
                                title: "Tekrar Sipariş",
                                subtitle: "Önceki siparişin",
                                color: .blue
                            ){}
                        )
                    }
                    
                    NavigationLink {
                        FavoritesView()
                    } label: {
                        QuickActionCard(
                            quickAction: QuickAction(
                                icon: "heart.fill",
                                title: "Favoriler",
                                subtitle: "Beğendiğin ürünler",
                                color: .blue
                            ){}
                        )
                    }
                    
                    QuickActionCard(
                        quickAction: QuickAction(
                            icon: "percent",
                            title: "İndirimler",
                            subtitle: "Özel fırsatlar",
                            color: .blue
                        ){}
                    )
                    
                    QuickActionCard(
                        quickAction: QuickAction(
                            icon: "gift.fill",
                            title: "Hediye Kutusu",
                            subtitle: "Özel paketler",
                            color: .blue
                        ){}
                    )
                    
                }
            }
        }
        .padding(.top, 24)
    }
    
    //MARK: - Category Section
    private var categoriesSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Kategoriler")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Tümü") {
                    // Action
                }
                .font(.subheadline)
                .foregroundColor(.green)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(shopViewModel.categories){ category in
                        NavigationLink {
                            SubShopView(category: category)
                        } label: {
                            CategoryCard(category: category)
                        }
                    }
                }
                .padding(.bottom)
            }
        }
        .padding(.top)
    }
    
    //MARK: - Seasonal Section
    private var seasonalHighlightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Mevsimin Favorileri")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Tümü") {
                    // Action
                }
                .font(.subheadline)
                .foregroundColor(.green)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(productViewModel.products.filter{$0.subCategory?.isInSeason ?? false }) { product in
                        NavigationLink {
                            ProductDetailView(product: product)
                        } label: {
                            ProductCard(product: product){
                                cartViewModel.addItem(product: product)
                            }
                        }
                        .tint(.primary)
                        .haptic(.medium)
                    }
                }
            }
        }
        .padding(.top, 24)
    }
    
    //MARK: - Recipe Sections
    private var recipesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Tarif İlhamı")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Tümü") {
                    // Action
                }
                .font(.subheadline)
                .foregroundColor(.green)
            }
            .padding(.horizontal, 20)
            
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
            }
        }
        .padding(.top, 24)
    }
}
