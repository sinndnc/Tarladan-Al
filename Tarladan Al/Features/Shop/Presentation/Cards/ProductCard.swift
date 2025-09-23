//
//  ProductCardView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/15/25.
//
import SwiftUI
struct ProductCard: View {
    let product: Product
    let action: () -> Void
    @State private var showingAddedToCart = false
    @State private var isPressed = false
    @State private var quantity: Int = 1
    @State private var isFavorite = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Section with Overlay
            ZStack(alignment: .topTrailing) {
                // Product Image
                AsyncImage(url: URL(string: product.images.first ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 140)
                        .clipped()
                } placeholder: {
                    ZStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 140)
                        
                        VStack(spacing: 6) {
                            Image(systemName: "photo")
                                .font(.system(size: 24))
                                .foregroundColor(.gray.opacity(0.6))
                            
                            Text("Resim Yükleniyor...")
                                .font(.caption2)
                                .foregroundColor(.gray.opacity(0.8))
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Overlays
                VStack {
                    HStack {
                        // Organic Badge
                        if product.isOrganic {
                            HStack(spacing: 4) {
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 8))
                                Text("ORGANİK")
                                    .font(.system(size: 9))
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                LinearGradient(
                                    colors: [Color.green, Color.green.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: .green.opacity(0.3), radius: 2, x: 0, y: 1)
                        }
                        
                        Spacer()
                        
                        // Favorite Button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                isFavorite.toggle()
                            }
                        }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(isFavorite ? .red : .white)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                )
                        }
                        .scaleEffect(isFavorite ? 1.1 : 1.0)
                    }
                    
                    Spacer()
                    
                    // Stock Status Overlay
                    if product.quantity <= 0 {
                        HStack {
                            Spacer()
                            Text("STOKTA YOK")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.9))
                                .clipShape(Capsule())
                            Spacer()
                        }
                    }
                }
                .padding(8)
            }
            
            // Content Section
            VStack(alignment: .leading, spacing: 8) {
                // Title and Stock
                    Text(product.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    
                
                // Farmer Info
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.blue)
                        
                        Text(product.farmerName)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                        
                        Text(product.locationName)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                // Price Section
                HStack(alignment: .bottom) {
                    HStack(spacing: 2) {
                        Text("\(product.price, specifier: "%.2f") ₺")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        
                        Text("/ \(product.unit)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Quantity Selector (when not in cart)
                    if !showingAddedToCart && product.quantity > 0 {
                        HStack(spacing: 5) {
                            Button(action: {
                                if quantity > 1 {
                                    quantity -= 1
                                }
                            }) {
                                Image(systemName: "minus")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(.blue)
                                    .frame(width: 20, height: 20)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            .disabled(quantity <= 1)
                            
                            Text("\(quantity)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .frame(minWidth: 20)
                            
                            Button(action: {
                                if quantity < Int(product.quantity) {
                                    quantity += 1
                                }
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(.blue)
                                    .frame(width: 20, height: 20)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            .disabled(quantity >= Int(product.quantity))
                        }
                    }
                }
               
                
                // Add to Cart Button
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        action()
                        addToCart()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: showingAddedToCart ? "checkmark.circle.fill" : "cart.badge.plus")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                        
                        Text(showingAddedToCart ? "Sepette!" : "Sepete Ekle")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            colors: showingAddedToCart ?
                                [Color.green, Color.green.opacity(0.8)] :
                                [Color.blue, Color.blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(
                        color: (showingAddedToCart ? Color.green : Color.blue).opacity(0.3),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
                }
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .disabled(product.quantity <= 0)
                .opacity(product.quantity <= 0 ? 0.6 : 1.0)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        )
    }
    
    private func addToCart() {
        showingAddedToCart = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingAddedToCart = false
                quantity = 1
            }
        }
    }
}
