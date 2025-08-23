//
//  Product+Extension.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/21/25.
//

import Foundation

extension Product {
    
    func isFavorite(_ products : [Product]) -> Bool {
        products.contains(where: { $0.id == self.id })
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["id"] = id
        
        dict["id"] = id
        dict["farmerId"] = farmerId
        dict["farmerName"] = farmerName
        dict["farmerPhone"] = farmerPhone
        dict["categoryName"] = categoryName
        dict["subCategoryName"] = subCategoryName
        dict["title"] = title
        dict["description"] = description
        dict["price"] = price
        dict["unit"] = unit
        dict["quantity"] = quantity
        dict["images"] = images
        dict["location"] = location
        dict["locationName"] = locationName
        dict["createdAt"] = createdAt
        dict["updatedAt"] = updatedAt
        dict["isActive"] = isActive
        dict["isOrganic"] = isOrganic
        dict["harvestDate"] = harvestDate
        dict["expiryDate"] = expiryDate
        
        return dict
    }
}
