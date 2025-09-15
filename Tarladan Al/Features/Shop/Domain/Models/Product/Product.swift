//
//  Product.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import Foundation
import FirebaseFirestore

struct Product: FirebaseModel {
    @DocumentID var id: String?
    let farmerId: String
    let farmerName: String
    let farmerPhone: String
    let categoryName: String
    let subCategoryName: String
    let title: String
    let description: String
    let price: Double
    let unit: String
    let quantity: Double
    let images: [String]
    let location: GeoPoint
    let locationName: String
    let createdAt: Date
    let updatedAt: Date
    let isActive: Bool
    let isOrganic: Bool
    let harvestDate: Date?
    let expiryDate: Date?
    
    var category: ProductCategory? {
        return ShopViewModel.shared.getCategory(by: categoryName)
    }
    
    var subCategory: ProductSubCategory? {
        return ShopViewModel.shared.getSubCategory(by: title)
    }
}
