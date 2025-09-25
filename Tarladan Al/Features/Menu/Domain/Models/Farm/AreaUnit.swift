//
//  AreaUnit.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/26/25.
//
import Foundation


enum AreaUnit: String, CaseIterable {
    case dönüm = "dönüm"
    case metrekare = "m²"
    case hektar = "hektar"
    
    var conversionToSquareMeters: Double {
        switch self {
        case .dönüm: return 1000
        case .metrekare: return 1
        case .hektar: return 10000
        }
    }
}
