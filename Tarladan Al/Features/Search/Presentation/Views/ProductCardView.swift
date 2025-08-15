//
//  ProductCardView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/15/25.
//
import SwiftUI

struct ProductCardView: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Ürün resmi
            AsyncImage(url: URL(string: product.images.first ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(height: 120)
            .clipped()
            .cornerRadius(8)
            
            // Ürün bilgileri
            VStack(alignment: .leading, spacing: 4) {
                // Başlık ve organik badge
                HStack {
                    Text(product.title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if product.isOrganic {
                        Text("ORG")
                            .font(.caption2)
                            .bold()
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
                
                // Fiyat
                Text("\(product.price, specifier: "%.2f") ₺/\(product.unit)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.green)
                
                // Çiftçi ve konum
                VStack(alignment: .leading, spacing: 2) {
                    Text(product.farmerName)
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text(product.locationName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                // Alt bilgiler
                HStack {
                    // Stok durumu
                    if product.quantity > 0 {
                        Label("\(product.quantity, specifier: "%.0f") \(product.unit)", systemImage: "cube.box")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    } else {
                        Label("Stokta yok", systemImage: "exclamationmark.triangle")
                            .font(.caption2)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    // Hasat/Son kullanma tarihi
                    if let harvestDate = product.harvestDate {
                        Label(formatDate(harvestDate), systemImage: "calendar")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter.string(from: date)
    }
}
