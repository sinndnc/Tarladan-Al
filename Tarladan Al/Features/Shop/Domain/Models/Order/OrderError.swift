//
//  OrderError.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/30/25.
//

import Foundation

enum OrderError: LocalizedError {
    case unkownError
    case emptyOrder
    case invalidDeliveryDate
    case productNotFound
    case invalidStatusTransition
    case firebaseError(String)
    
    var errorDescription: String? {
        switch self {
        case .emptyOrder:
            return "Teslimat ürün içermelidir"
        case .unkownError:
            return "Bilinmeyen bir hata oluştu"
        case .invalidDeliveryDate:
            return "Teslimat tarihi gelecekte olmalıdır"
        case .productNotFound:
            return "Üründen bilgiler bulunamadı"
        case .firebaseError(let error):
            return "Bilinmeyen bir hata oluştu: \(error)"
        case .invalidStatusTransition:
            return "Geçersiz durum değişikliği"
        }
    }
}
