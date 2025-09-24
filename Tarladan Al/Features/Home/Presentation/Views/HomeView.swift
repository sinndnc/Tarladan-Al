//
//  HomeView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var rootViewModel: RootViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject private var shopViewModel: ShopViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var recipeViewModel: RecipeViewModel
    @EnvironmentObject private var productViewModel: ProductViewModel
    @EnvironmentObject private var deliveryViewModel: DeliveryViewModel
    
    var body: some View {
        NavigationStack{
            List{
                if let delivery = deliveryViewModel.currentDelivery {
                    Section{
                        DeliveryStatusCard(delivery:delivery)
                    }
                }
                
                quickActionsSection
                
                categoriesSection
                
                seasonalHighlightsSection
                
                recipesSection
            }
            .background(Color(.systemGray6))
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    headerSection
                }
                ToolbarItem(placement: .topBarTrailing) {
                    tralingSection
                }
            }
            .sheet(isPresented: $rootViewModel.showingLocation) {
                if let user =  userViewModel.user {
                    LocationPickerView(addresses: user.addresses)
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
                rootViewModel.showingLocation = true
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
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        Section(header: Text("Hızlı Erişim")){
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
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
        .listRowBackground(Color.clear)
    }
    
    //MARK: - Category Section
    private var categoriesSection: some View {
        Section(header: Text("Kategoriler") ){
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(shopViewModel.categories){ category in
                        NavigationLink {
                            SubShopView(category: category)
                        } label: {
                            CategoryCard(category: category)
                        }
                    }
                }
            }
        }
        .listRowBackground(Color.clear)
    }
    
    //MARK: - Seasonal Section
    private var seasonalHighlightsSection: some View {
        Section(header: Text("Mevsimin Favorileri")){
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
        .listRowBackground(Color.clear)
    }
    
    //MARK: - Recipe Sections
    private var recipesSection: some View {
        Section(header:Text("Tarif İlhamı")){
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
        .listRowBackground(Color.clear)
    }
}


extension HomeView{
    
    
    var quickActions: [QuickAction] {
        [
            QuickAction(
                icon: "clock.arrow.circlepath",
                title: "Tekrar Sipariş",
                subtitle: "Önceki siparişin",
                color: .blue
            ) {
                
            },
            QuickAction(
                icon: "heart.fill",
                title: "Favoriler",
                subtitle: "Beğendiğin ürünler",
                color: .blue)
            {
                
            },
            QuickAction(
                icon: "percent",
                title: "İndirimler",
                subtitle: "Özel fırsatlar",
                color: .blue
            ) {
                
            },
            QuickAction(
                icon: "gift.fill",
                title: "Hediye Kutusu",
                subtitle: "Özel paketler",
                color: .blue
            ) {
                
            }
        ]
    }
}
