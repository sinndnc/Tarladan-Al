//
//  IrrigationType.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/26/25.
//
import Foundation

enum IrrigationType: String, CaseIterable {
    case damla = "Damla Sulama"
    case yağmurlama = "Yağmurlama"
    case salma = "Salma Sulama"
    case yeraltı = "Yeraltı Sulama"
    case yok = "Sulama Yok"
    
    var icon: String {
        switch self {
        case .damla: return "drop.fill"
        case .yağmurlama: return "cloud.rain.fill"
        case .salma: return "water.waves"
        case .yeraltı: return "arrow.down.circle.fill"
        case .yok: return "xmark.circle"
        }
    }
}
