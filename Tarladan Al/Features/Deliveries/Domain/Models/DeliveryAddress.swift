//
//  DeliveryAddress.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/6/25.
//


struct DeliveryAddress: Codable, Equatable {
    let street: String
    let city: String
    let district: String
    let postalCode: String
    let country: String
    let latitude: Double?
    let longitude: Double?
    let instructions: String?
    
    var fullAddress: String {
        return "\(street), \(district), \(city) \(postalCode)"
    }
}
