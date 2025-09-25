//
//  ProductCardView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/26/25.
//
import SwiftUI

struct ProductCardView: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 12) {
            // Ürün Resmi
            AsyncImage(url: URL(string: product.images.first ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.white)
                    }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Ürün Bilgileri
            VStack(alignment: .leading, spacing: 6) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack {
                    Text("\(String(format: "%.2f", product.price)) ₺")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    Text("/ \(product.unit)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 8) {
                    Label("\(String(format: "%.0f", product.quantity)) \(product.unit)", systemImage: "cube.box")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if product.isOrganic {
                        Label("Organik", systemImage: "leaf.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                // Durum Etiketi
                HStack {
                    Circle()
                        .fill(product.isActive ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    
                    Text(product.isActive ? "Satışta" : "Pasif")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(product.isActive ? .green : .red)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
