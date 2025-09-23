//
//  ProductGridView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/15/25.
//
import SwiftUI

struct ProductGridView: View {
    let products: [Product]
    let action: () -> Void
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(products, id: \.id) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    ProductCard(product: product,action: action)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
