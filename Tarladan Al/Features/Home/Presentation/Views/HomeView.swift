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
    @EnvironmentObject private var recipeViewModel: RecipeViewModel
    @EnvironmentObject private var productViewModel: ProductViewModel
    @EnvironmentObject private var deliveryViewModel: DeliveryViewModel
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    if let delivery = deliveryViewModel.currentDelivery {
                        deliveryStatusCard(delivery)
                    }
                    
                    if let banner = homeViewModel.featuredBanner {
                        featuredBanner(banner)
                    }
                    
                    quickActionsSection
                    
                    categoriesSection
                    
                    seasonalHighlightsSection
                    
                    recipesSection
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .background(Colors.System.background)
            .toolbarColorScheme(.dark, for:.navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Colors.UI.tabBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
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
    
    private var tralingSection: some View {
        HStack(spacing: 16) {
            NavigationLink {
                NotificationView()
            } label: {
                Image(systemName: "bell")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .haptic()
            
            Button(action: {}){
                Image(systemName: "line.3.horizontal")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .withHaptic()
        }
    }
    
    private func deliveryStatusCard(_ delivery: Delivery?) -> some View {
        VStack(alignment: .leading){
            Text("Sonraki Teslimat")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(Colors.Text.primary)
                
            VStack(spacing: 12) {
                if let delivery = delivery{
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            HStack{
                                Text("Güncel Teslimat Tarihi:")
                                    .font(.footnote)
                                    .foregroundColor(.primary)
                                Text("\(DateFormatter.shortFormatter.string(from: delivery.actualDeliveryDate ?? .now))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            HStack{
                                Text("Planlanan Teslimat Tarihi:")
                                    .font(.footnote)
                                    .foregroundColor(.primary)
                                Text("\(DateFormatter.shortFormatter.string(from: delivery.scheduledDeliveryDate))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        if delivery.status != .inTransit {
                            Button("Değiştir") {
                                //  viewModel.changeDeliveryTime()
                            }
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.green)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                    }
                    
                    HStack(spacing: 0) {
                        ForEach(0..<DeliveryStatus.allCases.count, id: \.self) { index in
                            HStack(spacing: 0) {
                                Circle()
                                    .fill(Double(index / 5) < delivery.status.progressValue ? Color.green : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                
                                if index < DeliveryStatus.allCases.count - 1 {
                                    Rectangle()
                                        .fill(Double(index / 5) < delivery.status.progressValue - 0.2 ? Color.green : Color.gray.opacity(0.3))
                                        .frame(height: 2)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    
                    HStack {
                        Image(systemName: "truck.box.fill")
                            .foregroundColor(.green)
                            .font(.title3)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(delivery.status.displayName)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.green)
                            
                            Text(delivery.orderNumber)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        NavigationLink("Detaylar") {
                            DeliveryDetailView(delivery: delivery)
                        }
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                    }
                }else{
                    HStack{
                        Spacer()
                        Text("You have no pending deliveries 😔")
                        Spacer()
                    }
                }
            }
            .padding(16)
            .background(.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .padding()
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
    
    // MARK: - Quick Actions
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
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 24)
    }
    
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
                            CategoryCardView(category: category)
                        }
                    }
                }
                .padding(.bottom)
                .padding(.horizontal)
            }
        }
        .padding(.top)
    }
    
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
                                
                            }
                        }
                        .tint(.primary)
                        .haptic(.medium)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 24)
    }
    
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
                        RecipeCardView(recipe: recipe)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 24)
    }
}
