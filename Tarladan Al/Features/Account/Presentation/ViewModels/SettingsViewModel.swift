//
//  SettingsViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @ObservedObject var themeManager: ThemeManager
    
    init(themeManager: ThemeManager) {
        self.themeManager = themeManager
    }
    
    
}
