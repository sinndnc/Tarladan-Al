//
//  RecipeCardView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/15/25.
//
import SwiftUI
import Foundation

struct RecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Resim
            AsyncImage(url: URL(string: recipe.imageName)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        Image(systemName: "photo")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
            }
            .frame(height: 160)
            .clipped()
            .overlay(alignment: .topTrailing) {
                // Zorluk seviyesi
                HStack(spacing: 4) {
                    Image(systemName: recipe.difficulty.icon)
                    Text(recipe.difficulty.rawValue)
                        .font(.caption.weight(.medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background {
                    Capsule()
                        .fill(recipe.difficulty.color.opacity(0.8))
                }
                .padding(8)
            }
            
            // İçerik
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(recipe.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                HStack {
                    // Kategori
                    Label(recipe.category.rawValue, systemImage: recipe.category.icon)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Süre ve porsiyon
                    HStack(spacing: 12) {
                        Label("\(recipe.totalTime)'", systemImage: "clock")
                        Label("\(recipe.servings)", systemImage: "person.2")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .frame(width: 275)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
