//
//  ProductImageCarousel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/15/25.
//
import SwiftUI

struct ProductImageCarousel: View {
    let images: [String]
    @Binding var selectedIndex: Int
    
    var body: some View {
        VStack {
            TabView(selection: $selectedIndex) {
                ForEach(Array(images.enumerated()), id: \.offset) { index, imageUrl in
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.title)
                                    .foregroundColor(.gray)
                            )
                    }
                    .tag(index)
                }
            }
            .frame(height: 250)
            .tabViewStyle(PageTabViewStyle())
            
            // Resim sayfa göstergesi
            if images.count > 1 {
                HStack {
                    ForEach(0..<images.count, id: \.self) { index in
                        Circle()
                            .fill(index == selectedIndex ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 8)
            }
        }
    }
}
