//
//  MenuCategory.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/25/25.
//
import SwiftUI

enum MenuCategory: String, CaseIterable {
    case producer = "producer"
    case guarantee = "guarantee"
    case quality = "quality"
    
    var displayName: String {
        switch self {
        case .producer: return "Üretici İşlemleri"
        case .guarantee: return "Güvence ve Yasal İşlemler"
        case .quality: return "Kalite ve Sertifikasyon"
        }
    }
}
