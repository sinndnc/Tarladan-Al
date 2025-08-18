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
                // Tümü butonu
                Button(action: { selectedCategory = nil }) {
                    CategoryChip(
                        title: "Tümü",
                        count: viewModel.products.count,
                        isSelected: selectedCategory == nil
                    ){
                        
                    }
                }
                
                // Kategori butonları
                ForEach(categories, id: \.name) { category in
                    Button(action: { 
                        selectedCategory = selectedCategory?.name == category.name ? nil : category 
                    }) {
                        CategoryChip(
                            title: "Tümü",
                            count: viewModel.products.count,
                            isSelected: selectedCategory == nil
                        ){
                            
                        }
                    }
                }
            }
        }
    }
}
