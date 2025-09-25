//
//  Farm.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/26/25.
//
import FirebaseFirestore
import SwiftUI

struct Farm: Identifiable, Codable {
    @DocumentID var id: String?
    let farmerId: String
    let farmerName: String
    let name: String
    let description: String
    let location: GeoPoint
    let locationName: String
    let address: String
    let area: Double // Dönüm cinsinden alan
    let areaUnit: String // "dönüm", "m²", "hektar"
    let soilType: String // Toprak tipi
    let irrigationType: String // Sulama tipi
    let images: [String]
    let coordinates: [GeoPoint] // Tarla sınırları için koordinatlar
    let createdAt: Date
    let updatedAt: Date
    let isActive: Bool
    let crops: [String] // Yetiştirilen ürünler
    let certifications: [String] // Sertifikalar (Organik, GAP, vb.)
    let hasWaterAccess: Bool
    let hasElectricity: Bool
    
    // Computed properties
    var formattedArea: String {
        return String(format: "%.2f %@", area, areaUnit)
    }
    
    var mainImage: String {
        return images.first ?? ""
    }
    
    var cropsList: String {
        return crops.joined(separator: ", ")
    }
    
    var certificationsList: String {
        return certifications.isEmpty ? "Yok" : certifications.joined(separator: ", ")
    }
}

