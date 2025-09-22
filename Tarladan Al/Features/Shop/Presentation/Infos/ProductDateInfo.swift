//
//  ProductDateInfo.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/15/25.
//
import SwiftUI

struct ProductDateInfo: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tarih Bilgileri")
                .font(.headline)
            
            VStack(spacing: 4) {
                if let harvestDate = product.harvestDate {
                    HStack {
                        Label("Hasat Tarihi", systemImage: "calendar")
                        Spacer()
                        Text(formatDate(harvestDate))
                            .foregroundColor(.green)
                    }
                    .font(.caption)
                }
                
                if let expiryDate = product.expiryDate {
                    HStack {
                        Label("Son Kullanma", systemImage: "clock.badge.exclamationmark")
                        Spacer()
                        Text(formatDate(expiryDate))
                            .foregroundColor(.red)
                    }
                    .font(.caption)
                }
                
                HStack {
                    Label("İlan Tarihi", systemImage: "plus.circle")
                    Spacer()
                    Text(formatDate(product.createdAt))
                        .foregroundColor(.secondary)
                }
                .font(.caption)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}
