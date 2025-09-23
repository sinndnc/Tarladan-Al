//
//  SubCategoryCardView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/15/25.
//
import SwiftUI

struct SubCategoryCard: View {
    let subCategory: ProductSubCategory
    
    var body: some View {
        HStack(spacing: 12) {
            // Sol taraf - İkon ve depolama bilgisi
            VStack(spacing: 8) {
                // Ana ikon
                Text(subCategory.icon)
                    .font(.title)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color(.systemGray6))
                    )
                
                // Depolama ikonu
                StorageIconView(storageType: subCategory.storageType)
            }
            
            // Orta kısım - Ana bilgiler
            VStack(alignment: .leading, spacing: 6) {
                // Ürün adı ve sezon durumu
                HStack {
                    Text(subCategory.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if subCategory.isInSeason {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                    }
                    
                    Spacer()
                }
                
                // Varyantlar
                if !subCategory.variants.isEmpty {
                    Text(subCategory.variants.prefix(2).joined(separator: " • "))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                // Alt bilgiler
                HStack(spacing: 12) {
                    // Sezon bilgisi
                    if !subCategory.seasonalityMonths.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.caption2)
                            Text(subCategory.seasonDisplayText)
                                .font(.caption2)
                        }
                        .foregroundColor(subCategory.isInSeason ? .green : .secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(Color(.systemGray6))
                        )
                    }
                    
                    // Raf ömrü
                    HStack(spacing: 4) {
                        Image(systemName: "timer")
                            .font(.caption2)
                        Text("\(subCategory.shelfLife)g")
                            .font(.caption2)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(subCategory.shelfLifeCategory.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(subCategory.shelfLifeCategory.color.opacity(0.1))
                    )
                    
                    Spacer()
                }
            }
            
            // Sağ taraf - Navigasyon ok
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
                .opacity(0.6)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08),radius: 8,x: 0,y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [
                            .clear,
                            Color(.systemGray5).opacity(0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
      
    }
}

// MARK: - Enhanced Storage Icon View
struct StorageIconView: View {
    let storageType: StorageType
    
    var body: some View {
        Group {
            switch storageType {
            case .refrigerated:
                Image(systemName: "snowflake")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            case .frozen:
                Image(systemName: "snow")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            case .roomTemperature:
                Image(systemName: "thermometer.medium")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .yellow],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            case .dryPlace:
                Image(systemName: "sun.max.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            case .cellar:
                Image(systemName: "archivebox.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.gray, .secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .font(.caption)
        .frame(width: 20, height: 20)
        .padding(6)
        .background(
            Circle()
                .fill(Color(.systemGray6))
        )
    }
}
