//
//  SearchView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI

struct SearchView: View {

    
    @EnvironmentObject private var viewModel : SearchViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    CategoryScrollView(
                        categories: viewModel.categories,
                        selectedCategory: $viewModel.selectedCategory
                    )
                    
                    ProductGridView(
                        products: viewModel.filteredProducts(
                            category: viewModel.selectedCategory,
                            searchText: viewModel.searchText
                        )
                    )
                }
                .padding(.horizontal)
            }
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText,isPresented: $viewModel.isShowingSearchable, prompt: "Search for products")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading) {
                        Text("Search")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Everything You Need")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { }) {
                        Image(systemName: "qrcode.viewfinder")
                            .foregroundColor(.primary)
                    }
                    .withHaptic()
                }
            }
            .sheet(isPresented: $viewModel.showFilters) {
                FilterSheet(viewModel: viewModel)
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Ürünler yükleniyor...")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Sonuç bulunamadı")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Arama teriminizi değiştirmeyi veya filtreleri temizlemeyi deneyin")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button("Filtreleri Temizle") {
//                viewModel.clearAllFilters()
            }
            .foregroundColor(.green)
            .font(.system(size: 16, weight: .medium))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}


struct FilterSheet: View {
    @ObservedObject var viewModel: SearchViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
//                    Text("Kategori")
//                        .font(.headline)
//                        .fontWeight(.semibold)
//                    
//                    LazyVGrid(columns: [
//                        GridItem(.flexible()),
//                        GridItem(.flexible())
//                    ], spacing: 12) {
//                        ForEach(viewModel.categories, id: \.self) { category in
//                            Button(action: {
//                                viewModel.selectCategory(category)
//                            }) {
//                                Text(category)
//                                    .font(.system(size: 14))
//                                    .padding(.horizontal, 16)
//                                    .padding(.vertical, 10)
//                                    .frame(maxWidth: .infinity)
//                                    .background(viewModel.selectedCategory == category ? Color.green : Color(.systemGray6))
//                                    .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
//                                    .cornerRadius(8)
//                            }
//                        }
//                    }
                }
                
//                VStack(alignment: .leading, spacing: 12) {
//                    Text("Sıralama")
//                        .font(.headline)
//                        .fontWeight(.semibold)
//                    
//                    VStack(spacing: 8) {
//                        ForEach(viewModel.sortOptions, id: \.self) { option in
//                            Button(action: {
//                                viewModel.selectSortOption(option)
//                            }) {
//                                HStack {
//                                    Text(option)
//                                        .font(.system(size: 16))
//                                        .foregroundColor(.primary)
//                                    
//                                    Spacer()
//                                    
//                                    if viewModel.sortOption == option {
//                                        Image(systemName: "checkmark")
//                                            .foregroundColor(.green)
//                                            .font(.system(size: 16, weight: .semibold))
//                                    }
//                                }
//                                .padding(.horizontal, 16)
//                                .padding(.vertical, 12)
//                                .background(Color(.systemGray6))
//                                .cornerRadius(8)
//                            }
//                        }
//                    }
//                }
                
                Spacer()
            }
            .padding(20)
            .navigationTitle("Filtreler")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("İptal") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Uygula") {
                    presentationMode.wrappedValue.dismiss()
                }
                .fontWeight(.semibold)
                .foregroundColor(.green)
            )
        }
    }
}
#Preview{
    SearchView()
}
