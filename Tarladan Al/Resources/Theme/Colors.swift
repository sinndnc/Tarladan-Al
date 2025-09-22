//
//  FarmColors.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/29/25.
//

import SwiftUI

struct Colors {
    
    // MARK: Ana Sistem Renkleri
    struct System {
        static let surface = Color("Surface")
        static let primary = Color("Primary")
        static let secondary = Color("Secondary")
        static let background = Color("Background")
        static let backgroundSecondary = Color("BackgroundSecondary")
    }
    
    // MARK: Metin Renkleri
    struct Text {
        static let primary = Color("TextPrimary")
        static let secondary = Color("TextSecondary")
    }
    
    // MARK: Başlık Renkleri
    struct Title {
        static let primary = Color("TitlePrimary")
        static let secondary = Color("TitleSecondary")
    }
    
    // MARK: Durum Renkleri
    struct Status {
        static let success = Color("Success")
        static let successLight = Color("FarmSuccessLight")
        static let warning = Color("Warning")
        static let warningLight = Color("WarningLight")
        static let error = Color("Error")
        static let errorLight = Color("ErrorLight")
        static let info = Color("Info")
        static let infoLight = Color("InfoLight")
    }
    
    // MARK: UI Element Renkleri
    struct UI {
        static let border = Color("Border")
        static let tabActive = Color("TabActive")
        static let tabInactive = Color("TabInactive")
        static let tabBackground = Color("TabBackground")
        static let separator = Color("Separator")
        static let overlay = Color("Overlay")
    }
}
