//
//  ProductCategory.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//

import Foundation
import SwiftUI

struct ProductCategory: Identifiable, Codable {
    var id = UUID()
    let name: String
    let icon: String
    let colorHex: String
    let subCategories: [ProductSubCategory]
    let description: String
    
    var color: Color {
        Color(hex: colorHex)
    }
}
