//
//  DietaryPreference.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//


struct DietaryPreference: Codable, Hashable {
    var vegetarian: Bool = false
    var vegan: Bool = false
    var glutenFree: Bool = false
    var dairyFree: Bool = false
    var nutFree: Bool = false
    var organic: Bool = true
    var localProduce: Bool = true
    var allergies: [String] = []
    var dislikes: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case vegetarian, vegan, organic, allergies, dislikes
        case glutenFree = "gluten_free"
        case dairyFree = "dairy_free"
        case nutFree = "nut_free"
        case localProduce = "local_produce"
    }
}