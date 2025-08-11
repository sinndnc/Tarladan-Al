//
//  FavoritesView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//
import SwiftUI

struct FavoritesView: View {
    var body: some View {
        List {
            Section("Favori Ürünlerim") {
                ForEach(0..<3) { index in
                    HStack {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading) {
                            Text("Organik Domates \(index + 1)")
                                .font(.headline)
                            Text("₺\((index + 1) * 15)/kg")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Favorilerim")
        .navigationBarTitleDisplayMode(.inline)
    }
}
