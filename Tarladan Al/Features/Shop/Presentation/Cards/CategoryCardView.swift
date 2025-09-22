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
        VStack(spacing: 0) {
            // Header Section
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    // Category Name
                    Text(category.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    // Description
                    Text(category.description)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Icon with Background
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(category.color.opacity(0.1))
                        .frame(width: 64, height: 64)
                    
                    Text(category.icon)
                        .font(.system(size: 32))
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            
            Spacer()
            
            // Divider Line
            Rectangle()
                .fill(category.color.opacity(0.1))
                .frame(height: 1)
                .padding(.horizontal, 24)
            
            // Bottom Section
            HStack(alignment: .center, spacing: 12) {
                // Product Count
                HStack(spacing: 6) {
                    Image(systemName: "tag.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(category.color)
                    
                    Text("\(category.subCategories.count) ürün")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(category.color)
                }
                
                // Separator Dot
                Circle()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(width: 3, height: 3)
                
                // Seasonal Badge (if applicable)
                if hasSeasonalProducts {
                    HStack(spacing: 4) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.green)
                        
                        Text("Mevsimsel")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 0)
        
        // New Badge (when applicable)
        if shouldShowNewBadge {
            VStack {
                HStack {
                    Spacer()
                    
                    Text("YENİ")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red)
                        .cornerRadius(8)
                }
                Spacer()
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var hasSeasonalProducts: Bool {
        category.subCategories.contains { subCategory in
            !subCategory.seasonalityMonths.isEmpty &&
            subCategory.seasonalityMonths.count < 12
        }
    }
    
    private var shouldShowNewBadge: Bool {
        // Bu logic'i ihtiyacınıza göre customize edebilirsiniz
        false
    }
}
