//
//  LanguageManager.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    
    @AppStorage("languageSetting") var languageSetting: Language = .english
    
    var currentLanguage: Language {
        switch languageSetting {
        case .english : return .english
        case .turkish : return .turkish
        case .spanish : return .spanish
        case .العربية : return .العربية
        }
    }
    
    func setLanguage(_ language: Language) {
        languageSetting = language
        objectWillChange.send()
    }
}
