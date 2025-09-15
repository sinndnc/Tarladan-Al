//
//  Recipe.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import Foundation
import SwiftUICore
import FirebaseFirestore

// MARK: - Recipe Model
struct Recipe: FirebaseModel{
    @DocumentID var id: String?
    let title: String
    let description: String
    let imageName: String
    let prepTime: Int // dakika
    let cookTime: Int // dakika
    let servings: Int
    let difficulty: Difficulty
    let category: Category
    let ingredients: [Ingredient]
    let instructions: [String]
    let nutritionInfo: NutritionInfo?
    let tags: [String]
    
    enum Difficulty: String, CaseIterable, Codable {
        case easy = "Kolay"
        case medium = "Orta"
        case hard = "Zor"
        
        var color: Color {
            switch self {
            case .easy: return .green
            case .medium: return .orange
            case .hard: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .easy: return "1.circle.fill"
            case .medium: return "2.circle.fill"
            case .hard: return "3.circle.fill"
            }
        }
    }
    
    enum Category: String, CaseIterable, Codable {
        case breakfast = "Kahvaltı"
        case lunch = "Öğle Yemeği"
        case dinner = "Akşam Yemeği"
        case dessert = "Tatlı"
        case snack = "Atıştırmalık"
        case soup = "Çorba"
        case salad = "Salata"
        
        var icon: String {
            switch self {
            case .breakfast: return "sun.rise"
            case .lunch: return "sun.max"
            case .dinner: return "moon"
            case .dessert: return "birthday.cake"
            case .snack: return "leaf"
            case .soup: return "drop"
            case .salad: return "carrot"
            }
        }
    }
    
    var totalTime: Int {
        return prepTime + cookTime
    }
}

// MARK: - Ingredient Model
struct Ingredient: Identifiable, Hashable ,Codable {
    var id = UUID()
    let name: String
    let amount: String
    let unit: String
    
    var displayText: String {
        return "\(amount) \(unit) \(name)"
    }
}

// MARK: - Nutrition Info Model
struct NutritionInfo: Hashable , Codable {
    let calories: Int
    let protein: Double // gram
    let carbs: Double // gram
    let fat: Double // gram
    let fiber: Double? // gram
}
