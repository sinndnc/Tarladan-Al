//
//  Address.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import Foundation
import FirebaseFirestore

// MARK: - Address Model
struct Address: FirebaseModel {
    var id: String?
    let title: String
    let fullAddress: String
    let city: String
    let district: String
    var isDefault: Bool
}
