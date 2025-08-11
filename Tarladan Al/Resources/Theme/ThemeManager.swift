//
//  ThemeManager.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//

import Foundation
import UIKit
import SwiftUI

class ThemeManager: ObservableObject {
    
    @AppStorage("themeSetting") var themeSetting: Theme = .system
    
    var currentTheme: Theme {
        switch themeSetting {
        case .light: return .light
        case .dark: return .dark
        default: return .system
        }
    }
    
    func setTheme(_ theme: Theme) {
        withAnimation {
            themeSetting = theme
        }
    }
    
}
