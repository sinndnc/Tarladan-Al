//
//  MeasurementUnit.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//


enum MeasurementUnit: String, CaseIterable, Codable {
    case kilogram = "kg"
    case gram = "gr"
    case ton = "ton"
    case piece = "adet"
    case bunch = "demet"
    case basket = "sepet"
    case box = "kutu/kasa"
    case bag = "çuval"
    case liter = "litre"
    case bottle = "şişe"
    case jar = "kavanoz"
    case package = "paket"
    case dozen = "düzine"
    case meter = "metre"
    case squareMeter = "m²"
    
    var displayName: String {
        switch self {
        case .kilogram: return "Kilogram"
        case .gram: return "Gram"
        case .ton: return "Ton"
        case .piece: return "Adet"
        case .bunch: return "Demet"
        case .basket: return "Sepet"
        case .box: return "Kutu/Kasa"
        case .bag: return "Çuval"
        case .liter: return "Litre"
        case .bottle: return "Şişe"
        case .jar: return "Kavanoz"
        case .package: return "Paket"
        case .dozen: return "Düzine"
        case .meter: return "Metre"
        case .squareMeter: return "Metrekare"
        }
    }
}