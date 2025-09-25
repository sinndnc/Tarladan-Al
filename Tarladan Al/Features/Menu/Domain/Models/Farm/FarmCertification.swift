//
//  FarmCertification.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/26/25.
//
import Foundation

enum FarmCertification: String, CaseIterable {
    case organik = "Organik"
    case gap = "GAP (İyi Tarım Uygulamaları)"
    case globalGap = "GlobalGAP"
    case iso22000 = "ISO 22000"
    case halal = "Helal Sertifikası"
    case vegan = "Vegan Sertifikası"
    
    var icon: String {
        switch self {
        case .organik: return "leaf.fill"
        case .gap: return "checkmark.seal.fill"
        case .globalGap: return "globe"
        case .iso22000: return "doc.badge.gearshape"
        case .halal: return "moon.stars.fill"
        case .vegan: return "heart.fill"
        }
    }
}
