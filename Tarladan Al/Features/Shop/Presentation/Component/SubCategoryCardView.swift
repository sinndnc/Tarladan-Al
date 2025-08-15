//
//  SubCategoryCardView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/15/25.
//



import SwiftUI

struct SubCategoryCardView: View {
    
    let subCategory: ProductSubCategory
    
    var body: some View {
        HStack(spacing: 5) {
            // İkon
            Text(subCategory.icon)
                .font(.title2)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                // Ürün adı
                Text(subCategory.name)
                    .font(.headline)
                
                // Varyantlar
                if !subCategory.variants.isEmpty {
                    Text(subCategory.variants.prefix(3).joined(separator: ", "))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                // Sezonluk bilgi
                HStack() {
                    if !subCategory.seasonalityMonths.isEmpty {
                        Label("Sezon", systemImage: "calendar")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                    
                    Label("\(subCategory.shelfLife) gün", systemImage: "clock")
                        .font(.caption2)
                        .foregroundColor(.blue)
                }
            }
            Spacer()
        }
        .frame(height: 100)
        .padding(.vertical,10)
        .padding(.horizontal,5)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.red.opacity(0.2), lineWidth: 1)
        )
    }
    
}

struct StorageIconView: View {
    let storageType: StorageType
    
    var body: some View {
        Group {
            switch storageType {
            case .refrigerated:
                Image(systemName: "snowflake")
                    .foregroundColor(.blue)
            case .frozen:
                Image(systemName: "snow")
                    .foregroundColor(.cyan)
            case .roomTemperature:
                Image(systemName: "house")
                    .foregroundColor(.orange)
            case .dryPlace:
                Image(systemName: "sun.max")
                    .foregroundColor(.yellow)
            case .cellar:
                Image(systemName: "archive")
                    .foregroundStyle(.gray)
            }
        }
        .font(.caption)
    }
}
