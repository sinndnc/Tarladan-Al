//
//  StockStatus.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/12/25.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @State private var quantity: Int = 1
    @State private var showFullDescription: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Product Image
                AsyncImage(url: URL(string: product.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                        )
                }
                .frame(height: 300)
                .clipped()
                .cornerRadius(12)
                .padding()
                
                VStack(alignment: .leading, spacing: 16) {
                    // Product Name and Category
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(product.category)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    // Price Section
                    HStack {
                        VStack(alignment: .leading) {
                            HStack(spacing: 8) {
                                Text("₺\(product.price, specifier: "%.2f")")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                if let originalPrice = product.originalPrice {
                                    Text("₺\(originalPrice, specifier: "%.2f")")
                                        .font(.caption)
                                        .strikethrough()
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            if product.isOnSale {
                                Text("ON SALE")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.red)
                                    .cornerRadius(4)
                            }
                        }
                        
                        Spacer()
                        
                        // Stock Status
                        stockStatusView
                    }
                    
                    // Rating and Reviews
                    HStack {
                        HStack(spacing: 4) {
                            ForEach(0..<5, id: \.self) { index in
                                Image(systemName: index < Int(product.rating) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                            }
                        }
                        
                        Text("\(product.rating, specifier: "%.1f")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("(\(product.reviewCount) reviews)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Organic Badge
                    if product.isOrganic {
                        HStack {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.green)
                            Text("Organic")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    // Origin and Seasonality
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "location")
                                .foregroundColor(.blue)
                            Text("Origin: \(product.origin)")
                                .font(.subheadline)
                        }
                        
                        if let seasonality = product.seasonality {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.orange)
                                Text("Season: \(seasonality)")
                                    .font(.subheadline)
                            }
                        }
                    }
                    
                    // Nutrition Highlights
                    if !product.nutritionHighlights.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nutrition Highlights")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 8) {
                                ForEach(product.nutritionHighlights, id: \.self) { highlight in
                                    Text(highlight)
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.orange.opacity(0.1))
                                        .foregroundColor(.orange)
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(product.description)
                            .font(.body)
                            .lineLimit(showFullDescription ? nil : 3)
                        
                        if product.description.count > 100 {
                            Button(showFullDescription ? "Show Less" : "Show More") {
                                withAnimation(.easeInOut) {
                                    showFullDescription.toggle()
                                }
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                    }
                    
                    // Quantity Selector and Add to Cart
                    if product.stockStatus != .outOfStock {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Quantity:")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                HStack(spacing: 12) {
                                    Button("-") {
                                        if quantity > 1 {
                                            quantity -= 1
                                        }
                                    }
                                    .frame(width: 30, height: 30)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(6)
                                    .disabled(quantity <= 1)
                                    
                                    Text("\(quantity)")
                                        .font(.headline)
                                        .frame(minWidth: 30)
                                    
                                    Button("+") {
                                        quantity += 1
                                    }
                                    .frame(width: 30, height: 30)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(6)
                                }
                            }
                            
                            Button("Add to Cart - ₺\(product.price * Double(quantity), specifier: "%.2f")") {
                                // Add to cart action
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        .padding(.top, 8)
                    } else {
                        Text("Currently Out of Stock")
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var stockStatusView: some View {
        HStack {
            Circle()
                .fill(stockStatusColor)
                .frame(width: 8, height: 8)
            
            Text(product.stockStatus.text)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(stockStatusColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(stockStatusColor.opacity(0.1))
        .cornerRadius(6)
    }
    
    private var stockStatusColor: Color {
        switch product.stockStatus {
        case .inStock:
            return .green
        case .lowStock:
            return .orange
        case .outOfStock:
            return .red
        }
    }
}

// Preview
struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductDetailView(product: sampleProduct)
        }
    }
    
    static var sampleProduct = Product(
        name: "Organic Turkish Apples",
        category: "Fresh Fruits",
        price: 12.50,
        originalPrice: 15.00,
        image: "https://example.com/apple.jpg",
        isOrganic: true,
        description: "Fresh, crispy Turkish apples grown in the fertile valleys of Isparta. These premium quality apples are rich in vitamins and perfect for healthy snacking. Hand-picked at peak ripeness to ensure maximum flavor and nutritional value.",
        rating: 4.5,
        reviewCount: 127,
        isOnSale: true,
        stockStatus: .inStock,
        seasonality: "Autumn",
        nutritionHighlights: ["Vitamin C", "Fiber", "Antioxidants", "Low Calorie"],
        origin: "Isparta, Turkey"
    )
}
