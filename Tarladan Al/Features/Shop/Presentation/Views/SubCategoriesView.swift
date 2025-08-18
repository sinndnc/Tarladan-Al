//
//  CategoryProductsView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//
import SwiftUI

struct SubCategoriesView: View {
    
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
        .navigationTitle("Alt Kategoriler")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
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
                            Text(category.name)
                                .font(.headline)
                            Text("\(shopViewModel.categories.count) ürün mevcut")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
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
                        ProductsListView(category:category ,subCategory: subCategory)
                    } label: {
                        SubCategoryCardView(subCategory: subCategory)
                    }
                    .tint(.primary)
                    .haptic(.medium)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

