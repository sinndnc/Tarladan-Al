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
            HStack(spacing: 20) {
                VStack{
                    Button {
                        withAnimation {
                            selectedCategory = nil
                        }
                    } label: {
                        Text("Tümü")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(selectedCategory == nil ? .white : .gray)
                    }
                    if selectedCategory == nil {
                        Divider()
                            .frame(height: 2)
                            .background(Colors.System.surface)
                    }
                }
                ForEach(categories, id: \.name) { category in
                    VStack{
                        Button {
                            withAnimation {
                                selectedCategory = category
                            }
                        } label: {
                            Text(category.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(
                                    selectedCategory?.name == category.name ? .white : .gray
                                    
                                )
                        }
                        if selectedCategory?.name == category.name{
                            Divider()
                                .frame(height: 2)
                                .background(Colors.System.surface)
                        }
                    }
                }
            }
        }
        .padding(8)
        .background(Colors.UI.tabBackground)
    }
}
