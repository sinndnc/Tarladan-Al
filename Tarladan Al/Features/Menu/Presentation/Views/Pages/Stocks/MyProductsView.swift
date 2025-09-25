//
//  MyProductsView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/26/25.
//

import SwiftUI

struct MyProductsView: View {
    @State private var showingAddProduct = false
    @State private var selectedProduct: Product?
    @State private var showingUpdateStock = false
    @State private var showingDeleteAlert = false
    @State private var productToDelete: Product?
    
    @EnvironmentObject private var productViewModel: ProductViewModel
    
    var body: some View {
        Group {
            if productViewModel.products.isEmpty {
                emptyStateView
            } else {
                productListView
            }
        }
        .navigationTitle("Ürünlerim")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedProduct) { product in
            UpdateStockView(product: product) {
            }
        }
        .alert("Ürünü Sil", isPresented: $showingDeleteAlert) {
            Button("İptal", role: .cancel) { }
            Button("Sil", role: .destructive) {
                
            }
        } message: {
            Text("Bu ürünü silmek istediğinizden emin misiniz?")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Henüz Ürün Yok")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Ürün eklemek için + butonuna dokunun")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Ürün Ekle") {
                showingAddProduct = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private var productListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(productViewModel.products) { product in
                    ProductCardView(product: product)
                        .contextMenu {
                            Button {
                                selectedProduct = product
                                showingUpdateStock = true
                            } label: {
                                Label("Stok Güncelle", systemImage: "arrow.triangle.2.circlepath")
                            }
                            
                            Button {
//                                viewModel.toggleProductStatus(product)
                            } label: {
                                Label(
                                    product.isActive ? "Satışa Kapat" : "Satışa Aç",
                                    systemImage: product.isActive ? "pause.circle" : "play.circle"
                                )
                            }
                            
                            Button(role: .destructive) {
                                productToDelete = product
                                showingDeleteAlert = true
                            } label: {
                                Label("Sil", systemImage: "trash")
                            }
                        }
                        .onTapGesture {
                            selectedProduct = product
                            showingUpdateStock = true
                        }
                }
            }
            .padding()
        }
    }
}
