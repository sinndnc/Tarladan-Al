//
//  CategoryScrollView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/15/25.
//
import SwiftUI

struct CategoryScrollView: View {
    let categories: [ProductCategory]
    @Binding var selectedCategory: ProductCategory?
    @EnvironmentObject private var viewModel : SearchViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryChip(
                    title: "Tümü",
                    count: viewModel.products.count,
                    isSelected: selectedCategory == nil
                ){
                    selectedCategory = nil
                }
                
                ForEach(categories, id: \.name) { category in
                    CategoryChip(
                        title: category.name,
                        count: category.subCategories.count,
                        isSelected: selectedCategory?.name == category.name
                    ){
                        selectedCategory = category
                    }
                }
            }
        }
    }
}
