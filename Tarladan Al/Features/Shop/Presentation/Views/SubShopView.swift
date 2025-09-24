//
//  CategoryProductsView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//
import SwiftUI

struct SubShopView: View {
    
    @State var category : ProductCategory
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var shopViewModel: ShopViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                categoryInfoBanner
                subCategoriesSection
            }
        }
        .navigationTitle(category.name)
        .navigationSubtitleCompat("\(category.subCategories.count) Ürün mevcut")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                shopCardSection
            }
        }
        .sheet(isPresented: $shopViewModel.showCart) {
            CartView()
        }
    }
    
    private var shopCardSection: some View {
        Button(action: {
            shopViewModel.toggleCart()
        }) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bag")
                    .foregroundColor(.primary)
                    .badge(cartViewModel.items.count)
               
            }
        }
        .withHaptic(.medium)
    }
    
    private var categoryInfoBanner: some View {
        HStack(spacing: 16) {
            Text(category.icon)
                .font(.system(size: 50))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(category.description)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                if true {
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
        }
        .padding()
        .background(category.color.opacity(0.1))
        .cornerRadius(16)
        .padding()
    }
    
    private var subCategoriesSection: some View {
        Group {
            LazyVStack(spacing: 12) {
                ForEach(category.subCategories) { subCategory in
                    NavigationLink {
                        ProductsView(category:category ,subCategory: subCategory)
                    } label: {
                        SubCategoryCard(subCategory: subCategory)
                    }
                    .tint(.primary)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

