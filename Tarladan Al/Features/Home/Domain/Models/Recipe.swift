//
//  Recipe.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id = UUID()
    let title: String
    let duration: String
    let difficulty: String
    let image: String?
    let ingredients: [String]
    let instructions: [String]
    let category: String
    let rating: Double
    let reviewCount: Int
}

