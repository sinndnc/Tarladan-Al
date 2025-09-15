//
//  RecipeError.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/15/25.
//

import Foundation

enum RecipeError: LocalizedError {
    case unkownError
    case invalidDeliveryDate
    case productNotFound
    case invalidStatusTransition
    case firebaseError(String)
    
    var errorDescription: String? {
        switch self {
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
