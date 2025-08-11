//
//  Language.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//


import Foundation

enum Language: String, CaseIterable {
    case turkish = "Turkish"
    case english = "English"
    case spanish = "Español"
    case العربية = "العربية"
    
    
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .spanish:
            return "Español"
        case .turkish:
            return "Turkish"
        case .العربية:
            return "العربية"
        }
    }
}
