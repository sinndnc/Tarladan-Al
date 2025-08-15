//
//  StockStatus.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/12/25.
//
import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @State private var selectedImageIndex = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Ürün resimleri carousel
                ProductImageCarousel(
                    images: product.images,
                    selectedIndex: $selectedImageIndex
                )
                
                VStack(alignment: .leading, spacing: 16) {
                    // Başlık ve organik badge
                    HStack {
                        Text(product.title)
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        if product.isOrganic {
                            VStack {
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(.green)
                                Text("ORGANİK")
                                    .font(.caption2)
                                    .bold()
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    // Fiyat ve stok
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(product.price, specifier: "%.2f") ₺")
                                .font(.title)
                                .bold()
                                .foregroundColor(.green)
                            
                            Text("per \(product.unit)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Stok: \(product.quantity, specifier: "%.0f")")
                                .font(.subheadline)
                                .bold()
                            
                            Text(product.unit)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Çiftçi bilgileri
                    FarmerInfoCard(product: product)
                    
                    // Açıklama
                    if !product.description.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Açıklama")
                                .font(.headline)
                            
                            Text(product.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Kategori bilgisi
                    if let category = product.category,
                       let subCategory = product.subCategory {
                        ProductCategoryInfo(category: category, subCategory: subCategory)
                    }
                    
                    // Tarih bilgileri
                    ProductDateInfo(product: product)
                }
                .padding()
            }
        }
        .navigationTitle(product.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "heart")
                }
            }
        }
    }
}
