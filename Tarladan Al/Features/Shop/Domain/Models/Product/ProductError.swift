//
//  DeliveryError.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//

import Foundation

enum ProductError: LocalizedError {
    case unkownError
    case emptyItems
    case invalidDeliveryDate
    case productNotFound
    case invalidStatusTransition
    case firebaseError(String)
    
    var errorDescription: String? {
        switch self {
        case .emptyItems:
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
