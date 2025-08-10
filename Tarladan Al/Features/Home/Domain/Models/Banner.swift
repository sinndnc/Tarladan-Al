//
//  Banner.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import Foundation


struct Banner: Identifiable, Codable {
    let id = UUID()
    let title: String
    let subtitle: String
    let description: String
    let discountText: String?
    let buttonText: String
    let image: String?
    let backgroundColor: String
    let isActive: Bool
}
