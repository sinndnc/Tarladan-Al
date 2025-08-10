//
//  DeliveryError.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/6/25.
//

import Foundation


enum DeliveryError: LocalizedError {
    case unkownError
    case emptyItems
    case invalidDeliveryDate
    case deliveryNotFound
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
        case .deliveryNotFound:
            return "Teslimat bulunamadı"
        case .firebaseError(let error):
            return "Bilinmeyen bir hata oluştu: \(error)"
        case .invalidStatusTransition:
            return "Geçersiz durum değişikliği"
        }
    }
}
