//
//  RecipeDetailView 2.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/15/25.
//

import SwiftUI
import Foundation

struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var selectedTab: DetailTab = .ingredients
    @Environment(\.dismiss) private var dismiss
    
    enum DetailTab: String, CaseIterable {
        case ingredients = "Malzemeler"
        case instructions = "Tarif"
        case nutrition = "Besin Değerleri"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Image
                AsyncImage(url: URL(string: recipe.imageName)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }
                }
                .frame(height: 250)
                .clipped()
                
                // İçerik
                VStack(alignment: .leading, spacing: 20) {
                    // Başlık ve Bilgiler
                    VStack(alignment: .leading, spacing: 12) {
                        Text(recipe.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(recipe.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        // İstatistikler
                        HStack(spacing: 20) {
                            StatView(icon: "clock", label: "Süre", value: "\(recipe.totalTime) dk")
                            StatView(icon: "person.2", label: "Porsiyon", value: "\(recipe.servings)")
                            StatView(icon: recipe.difficulty.icon, label: "Zorluk", value: recipe.difficulty.rawValue)
                        }
                        
                        // Etiketler
                        if !recipe.tags.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(recipe.tags, id: \.self) { tag in
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.blue.opacity(0.1))
                                            .foregroundColor(.blue)
                                            .clipShape(Capsule())
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.horizontal, -16)
                        }
                    }
                    
                    // Tab Selector
                    HStack {
                        ForEach(DetailTab.allCases, id: \.self) { tab in
                            Button {
                                selectedTab = tab
                            } label: {
                                Text(tab.rawValue)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundColor(selectedTab == tab ? .primary : .secondary)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background {
                                        if selectedTab == tab {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.blue.opacity(0.1))
                                        }
                                    }
                            }
                        }
                    }
                    .padding(4)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Tab İçeriği
                    Group {
                        switch selectedTab {
                        case .ingredients:
                            IngredientsView(ingredients: recipe.ingredients)
                        case .instructions:
                            InstructionsView(instructions: recipe.instructions)
                        case .nutrition:
                            NutritionView(nutrition: recipe.nutritionInfo)
                        }
                    }
                    .animation(.easeInOut, value: selectedTab)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Kaydet") {
                    // Favorilere ekleme işlemi
                }
            }
        }
    }
}

struct StatView: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.caption.weight(.medium))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct IngredientsView: View {
    let ingredients: [Ingredient]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(ingredients) { ingredient in
                HStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 6, height: 6)
                    
                    Text(ingredient.displayText)
                        .font(.body)
                    
                    Spacer()
                }
                
                if ingredient.id != ingredients.last?.id {
                    Divider()
                }
            }
        }
    }
}

struct InstructionsView: View {
    let instructions: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1)")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(Circle().fill(Color.blue))
                    
                    Text(instruction)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
            }
        }
    }
}

struct NutritionView: View {
    let nutrition: NutritionInfo?
    
    var body: some View {
        Group {
            if let nutrition = nutrition {
                VStack(spacing: 16) {
                    HStack {
                        NutritionItem(label: "Kalori", value: "\(nutrition.calories)", unit: "kcal")
                        NutritionItem(label: "Protein", value: String(format: "%.1f", nutrition.protein), unit: "g")
                    }
                    
                    HStack {
                        NutritionItem(label: "Karbonhidrat", value: String(format: "%.1f", nutrition.carbs), unit: "g")
                        NutritionItem(label: "Yağ", value: String(format: "%.1f", nutrition.fat), unit: "g")
                    }
                    
                    if let fiber = nutrition.fiber {
                        HStack {
                            NutritionItem(label: "Lif", value: String(format: "%.1f", fiber), unit: "g")
                            Spacer()
                        }
                    }
                }
            } else {
                Text("Besin değerleri mevcut değil")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
    }
}

struct NutritionItem: View {
    let label: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value) \(unit)")
                .font(.headline.weight(.semibold))
                .foregroundColor(.blue)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
