//
//  CategoryCardView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/15/25.
//
import SwiftUI

struct CategoryCardView: View {
    let category: ProductCategory
    
    var body: some View {
        VStack(spacing: 16) {
            // Category Header
            HStack {
                ZStack(alignment: .topTrailing) {
                    if false {
                        Text("YENİ")
                            .zIndex(1)
                            .padding(4)
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.name)
                            .lineLimit(2)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        Text(category.description)
                            .lineLimit(2)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                Text(category.icon)
                    .font(.system(size: 40))
            }
            
            // Product Count and Seasonal Badge
            HStack {
                Text("\(category.subCategories.count) ürün")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(category.color)
                
                Spacer()
                
                if true {
                    HStack(spacing: 4) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.green)
                        Text("Mevsimsel")
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .frame(height: 150)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(category.color.opacity(0.2), lineWidth: 1)
        )
    }
}
