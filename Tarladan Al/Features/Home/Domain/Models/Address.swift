//
//  Address.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import Foundation


// MARK: - Address Model
struct Address: Identifiable, Codable {
    let id = UUID()
    let title: String
    let fullAddress: String
    let city: String
    let district: String
    let isDefault: Bool
}
