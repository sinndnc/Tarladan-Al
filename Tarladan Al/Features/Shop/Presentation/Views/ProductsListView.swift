//
//  ProductsListView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/15/25.
//

import SwiftUI

struct ProductsListView: View {
    
    @State var category: ProductCategory
    @State var subCategory : ProductSubCategory
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var shopViewModel: ShopViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                subcategoriesBar
                sortAndViewBar
                productsViewSection
            }
        }
        .navigationTitle(subCategory.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var sortAndViewBar: some View {
        HStack {
            Text("Sıralama: ")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Text(shopViewModel.sortOption.rawValue)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.green)
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    shopViewModel.setViewMode(.grid)
                }) {
                    Image(systemName: "square.grid.2x2")
                        .foregroundColor(.gray)
                }
                
                Button(action: {
                    shopViewModel.setViewMode(.list)
                }) {
                    Image(systemName: "list.bullet")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var subcategoriesBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(subCategory.variants,id: \.self) { product in
                    Button(action: {
//                        categoryViewModel.selectSubcategory(subcategory)
                    }) {
                        Text(product)
                            .font(.system(size: 14, weight: .medium))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
//                            .background(categoryViewModel.selectedSubcategory == subcategory ? category.color : Color(.systemGray6))
//                            .foregroundColor(categoryViewModel.selectedSubcategory == subcategory ? .white : .primary)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
    
    private var productsViewSection: some View{
        Group {
            if shopViewModel.viewMode == .grid {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 16) {
                    
                    let filteredProducts = shopViewModel.getProductsSubCategory(by: subCategory.name)
                    ForEach(filteredProducts,id:\.self) { product in
                        NavigationLink {
                            ProductDetailView(product: product)
                        } label: {
                            ProductCardView(product: product)
                        }
                        .tint(.primary)
                        .haptic(.medium)
                    }
                }
                .padding(.horizontal, 20)
            } else {
                LazyVStack(spacing: 12) {
                    let filteredProducts = shopViewModel.getProductsSubCategory(by: subCategory.name)
                    ForEach(filteredProducts,id:\.self) { product in
                        NavigationLink {
                            ProductDetailView(product: product)
                        } label: {
                            ProductCardView(product: product)
                        }
                        .tint(.primary)
                        .haptic(.medium)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}
