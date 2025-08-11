//
//  Theme.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//

import Foundation
import SwiftUICore

enum Theme : String, CaseIterable  {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
    
    var displayName : String {
        switch self {
        case .dark:
            "Dark Mode"
        case .light:
            "Light Mode"
        case .system:
            "System Mode"
        }
    }
    
}

extension Theme{
    
    var toColorScheme : ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        default:
            return .none
        }
    }
}
