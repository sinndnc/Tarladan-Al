//
//  SoilType.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/26/25.
//
import Foundation


enum SoilType: String, CaseIterable {
    case kumlu = "Kumlu"
    case killi = "Killi"
    case tınlı = "Tınlı"
    case turbalı = "Turbalı"
    case kireçli = "Kireçli"
    case balçıklı = "Balçıklı"
    
    var description: String {
        switch self {
        case .kumlu: return "Hızlı drene olur, hafif toprak"
        case .killi: return "Su tutar, ağır toprak"
        case .tınlı: return "İdeal tarım toprağı"
        case .turbalı: return "Organik madde açısından zengin"
        case .kireçli: return "Alkali, pH yüksek"
        case .balçıklı: return "Su tutma kapasitesi yüksek"
        }
    }
}
