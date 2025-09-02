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
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Featured Banner
                    if shopViewModel.showFeaturedBanner {
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
            .background(Colors.System.background)
            .toolbarColorScheme(.dark, for:.navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Colors.UI.tabBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    headerSection
                }
                ToolbarItem(placement: .topBarTrailing) {
                    shopCardSection
                }
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
    
    private var shopCardSection: some View {
        Button(action: {
            shopViewModel.toggleCart()
        }) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bag")
                    .foregroundColor(.primary)
                
                if cartViewModel.uniqueItemsCount > 0 {
                    Text("\(cartViewModel.uniqueItemsCount)")
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
            Text(shopViewModel.featuredTitle)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text(shopViewModel.featuredDescription)
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
                    ForEach(shopViewModel.quickActions) { quickAction in
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
                ForEach(shopViewModel.categories) { category in
                    NavigationLink {
                        SubShopView(category: category)
                    } label: {
                        CategoryCardView(category: category)
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

#Preview{
    ShopView()
}
