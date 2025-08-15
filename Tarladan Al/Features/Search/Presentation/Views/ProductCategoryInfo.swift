//
//  ProductCategoryInfo.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/15/25.
//
import SwiftUI

struct ProductCategoryInfo: View {
    let category: ProductCategory
    let subCategory: ProductSubCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Kategori Bilgileri")
                .font(.headline)
            
            HStack {
                Text(category.icon)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(category.name)
                        .font(.subheadline)
                        .bold()
                    
                    Text(subCategory.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Depolama bilgisi
//                StorageIconView(storageType: subCategory.storageType)
//                    .font(.title3)
            }
            
            // Raf ömrü bilgisi
            if subCategory.shelfLife > 0 {
                Label("Raf ömrü: \(subCategory.shelfLife) gün", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.orange.opacity(0.05))
        .cornerRadius(12)
    }
}
