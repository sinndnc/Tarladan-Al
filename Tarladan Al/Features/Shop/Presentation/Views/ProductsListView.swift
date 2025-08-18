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
    
    @State private var selectedVarient : String? = nil
    
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
        .searchable(text: .constant(""),prompt: Text("Search Productscard"))
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                shopCardSection
            }
        }
        .sheet(isPresented: $shopViewModel.showFilters) {
            CategoryFiltersSheet(viewModel: shopViewModel)
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
                        .foregroundColor(shopViewModel.viewMode == .grid  ? .green : .gray)
                }
                
                Button(action: {
                    shopViewModel.setViewMode(.list)
                }) {
                    Image(systemName: "list.bullet")
                        .foregroundColor(shopViewModel.viewMode == .list  ? .green : .gray)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var subcategoriesBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryChip(
                    title: "Tümü",
                    count: 0,
                    isSelected: selectedVarient == nil
                ){
                    selectedVarient = nil
                }
                
                ForEach(subCategory.variants,id: \.self) { varient in
                    CategoryChip(
                        title: varient,
                        count: 0,
                        isSelected: selectedVarient == varient
                    ){
                        selectedVarient = varient
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom)
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
                            ProductCardView(product: product){
                                cartViewModel.addItem(product: product)
                                shopViewModel.addToCart(product: product)
                            }
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
                            ProductCardView(product: product){
                                cartViewModel.addItem(product: product)
                                shopViewModel.addToCart(product: product)
                            }
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
